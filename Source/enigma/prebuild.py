#!/usr/bin/env python3
"""Prepare a copy of the GG2 source tree for ENIGMA.

Stopgap for ENIGMA bugs that can be fixed with a text rewrite. The repo source
stays valid GM8; the rewritten copy is only for ENIGMA builds. Each workaround
names the ENIGMA bug it covers; delete it once that bug is fixed upstream.

Bugs that need a structural rewrite (nested built-in dot access, string
switch) are fixed in the source, marked TODO(enigma). This script lints for
them so they don't come back.

Usage: prebuild.py <Source/gg2> <out dir> [--stub-extensions]
"""

import argparse
import html
import re
import shutil
import struct
import sys
import zlib
from pathlib import Path

# GM8 built-in instance variables. ENIGMA mis-compiles these behind a nested
# dot (a.b.x) but not behind a single dot (a.x).
BUILTINS = """x y xprevious yprevious xstart ystart hspeed vspeed direction speed
friction gravity gravity_direction alarm image_index image_speed image_xscale
image_yscale image_angle image_alpha image_blend image_number sprite_index
sprite_width sprite_height sprite_xoffset sprite_yoffset mask_index depth
visible solid persistent object_index bbox_left bbox_right bbox_top bbox_bottom
path_index path_position timeline_index""".split()

# Faucet Networking API. Prefixed with fct_ because buffer_* etc. clash with
# ENIGMA built-ins (this matches Faucet's own fct_ variant).
FAUCET = """append_file_to_buffer bit_get bit_set buffer_bytes_left buffer_clear
buffer_create buffer_destroy buffer_set_readpos buffer_size build_ubyte
debug_handles ipv4_lookup_create ipv6_lookup_create ip_is_v4 ip_is_v6
ip_lookup_create ip_lookup_destroy ip_lookup_has_next ip_lookup_next_result
ip_lookup_ready mac_addrs read_base64 read_byte read_double read_float read_hex
read_int read_short read_string read_ubyte read_uint read_ushort
set_little_endian set_little_endian_global socket_accept socket_connecting
socket_destroy socket_destroy_abortive socket_error socket_handle_io
socket_has_error socket_local_port socket_receivebuffer_size socket_remote_ip
socket_remote_port socket_send socket_sendbuffer_limit socket_sendbuffer_size
tcp_connect tcp_eof tcp_listen tcp_listening_v4 tcp_listening_v6 tcp_receive
tcp_receive_available tcp_set_nodelay udp_bind udp_broadcast udp_receive
udp_send write_base64 write_buffer write_buffer_part write_buffer_to_file
write_byte write_double write_float write_hex write_int write_short
write_string write_ubyte write_uint write_ushort read_binary_string
read_cstring read_delimited_binary_string read_delimited_string
write_binary_string""".split()

# Other extension functions with no native build yet (GG2DLL, Faucet Forwarding).
OTHER_EXTENSIONS = """GG2DLL_get_temp_filename GG2DLL_embed_PNG_leveldata
GG2DLL_extract_PNG_leveldata GG2DLL_compute_MD5 GG2DLL_imageHeight
GG2DLL_imageWidth GG2DLL_imagefSize upnp_set_description upnp_discover
upnp_error_string upnp_forward_port upnp_release_port""".split()

# EDL passes these C++ keywords through, so they can't be GML variable names.
RENAMES = {"char": "char_", "class": "class_", "private": "private_"}

# ENIGMA turns each script into a macro named after it; these names clash with
# members of ENIGMA's own object classes and break every object.
SCRIPT_RENAMES = {"serialize": "gg2_serialize", "deserialize": "gg2_deserialize"}

# ENIGMA bug: string_char_at returns a C++ char, not a string, so comparing it
# to "x" compares pointers. Route calls through a GML helper.
HELPERS = {
    "string_char_at": (
        "gml_string_char_at",
        "if (argument1 < 1 or argument1 > string_length(argument0))\n"
        '    return "";\n'
        "return string_copy(argument0, argument1, 1);\n",
    ),
}

# Resource names must be valid C++ identifiers in ENIGMA.
ROOM_RENAMES = {"Gang Garrison 2": "InitRoom"}

# GM8 strings have no escapes and may span lines.
SKIP_RE = re.compile(r'//[^\n]*|/\*.*?\*/|"[^"]*"|\'[^\']*\'', re.S)
CODE_TAG_RE = re.compile(
    r'(<argument kind="STRING">)(.*?)(</argument>)'
    r"|(<creationCode>)(.*?)(</creationCode>)",
    re.S,
)
# a.b.x, or f().x: the lhs of the built-in's dot is itself not a plain name.
NESTED_DOT_RE = re.compile(
    r"(?:(?<![\w.])[A-Za-z_]\w*(?:\[[^\]\n]*\])?(?:\.[A-Za-z_]\w*(?:\[[^\]\n]*\])?)+"
    r"|\))\s*\.(?:%s)\b" % "|".join(BUILTINS)
)
STRING_CASE_RE = re.compile(r"\bcase\s*[\"']")


def load_constants(path):
    text = path.read_text(encoding="utf-8")
    return {
        html.unescape(n): html.unescape(v)
        for n, v in re.findall(r'<constant name="([^"]*)" value="([^"]*)"/>', text)
    }


def word_re(words):
    return re.compile(
        r"\b(" + "|".join(sorted(map(re.escape, words), key=len, reverse=True)) + r")\b"
    )


class Rewriter:
    def __init__(self, constants, renames):
        self.constants = constants
        self.renames = renames
        self.const_re = word_re(constants)
        self.rename_re = word_re(renames)
        self.rewrites = [
            # ENIGMA bug: GMK constants are dropped. Inline their (literal) values.
            (self.const_re, lambda m: self.constants[m.group(1)]),
            (self.rename_re, lambda m: self.renames[m.group(1)]),
            # ENIGMA bug: `if(not x)` is emitted as `if(notx)`.
            (re.compile(r"\bnot\b\s*"), lambda m: "!"),
            # ENIGMA bug: `if (c) exit; else` fails to pair the else.
            (re.compile(r"\bexit\s*;"), lambda m: "{ exit; }"),
            # GM8 accepts a trailing ; inside a for header, ENIGMA doesn't.
            (
                re.compile(r"(for\s*\([^;()]*;[^;()]*;[^;()]*);\s*\)"),
                lambda m: m.group(1) + ")",
            ),
        ]

    def code(self, text):
        out, last = [], 0
        for m in SKIP_RE.finditer(text):
            plain = self.plain(text[last : m.start()])
            token = m.group(0)
            # ENIGMA bug: "a" + "b" becomes C++ const char* + const char*.
            if (
                token[0] in "\"'"
                and out
                and out[-1][:1] in ('"', "'")
                and PLUS_ONLY_RE.fullmatch(plain)
                and (merged := merge_literals(out[-1], token))
            ):
                out[-1] = merged
            else:
                out += [plain, token]
            last = m.end()
        out.append(self.plain(text[last:]))
        return "".join(out)

    def plain(self, text):
        for rx, rep in self.rewrites:
            text = rx.sub(rep, text)
        return text


PLUS_ONLY_RE = re.compile(r"\s*\+\s*")


def merge_literals(a, b):
    """Join two GML string literals into one, or None if no quote fits."""
    body = a[1:-1] + b[1:-1]
    for q in "\"'":
        if q not in body:
            return q + body + q
    return None


def strip_comments_and_strings(text):
    return SKIP_RE.sub(lambda m: re.sub(r"[^\n]", " ", m.group(0)), text)


def lint(name, code, problems):
    bare = strip_comments_and_strings(code)
    for m in NESTED_DOT_RE.finditer(bare):
        line = bare.count("\n", 0, m.start()) + 1
        problems.append(
            f"{name}:{line}: nested dot on built-in `{m.group(0)}` (use a temp var)"
        )
    for m in re.finditer(r"\bswitch\s*\(", bare):
        body_start = bare.find("{", m.end())
        depth, i = 0, body_start
        while i < len(bare):
            depth += {"{": 1, "}": -1}.get(bare[i], 0)
            if depth == 0:
                break
            i += 1
        # Strings are blanked in `bare`, so check the original text for string labels.
        if STRING_CASE_RE.search(code[body_start:i]):
            line = bare.count("\n", 0, m.start()) + 1
            problems.append(f"{name}:{line}: switch on strings (use if/else)")


def placeholder_png():
    def chunk(kind, data):
        return (
            struct.pack(">I", len(data))
            + kind
            + data
            + struct.pack(">I", zlib.crc32(kind + data))
        )

    ihdr = struct.pack(">IIBBBBB", 1, 1, 8, 6, 0, 0, 0)
    return (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", ihdr)
        + chunk(b"IDAT", zlib.compress(b"\0\0\0\0\0"))
        + chunk(b"IEND", b"")
    )


def fill_empty_backgrounds(out):
    # ENIGMA bug: a background with no image aborts resource transfer and
    # silently drops every resource after it.
    for xml in (out / "Backgrounds").rglob("*.xml"):
        if xml.name == "_resources.list.xml":
            continue
        png = xml.with_suffix(".png")
        if not png.exists():
            png.write_bytes(placeholder_png())


def rename_rooms(out):
    rooms = out / "Rooms"
    listing = rooms / "_resources.list.xml"
    text = listing.read_text(encoding="utf-8")
    for old, new in ROOM_RENAMES.items():
        text = text.replace(f'name="{old}"', f'name="{new}"')
        (rooms / f"{old}.xml").rename(rooms / f"{new}.xml")
    listing.write_text(text, encoding="utf-8")


def rename_scripts(out, renames):
    for old, new in renames.items():
        (path,) = (out / "Scripts").rglob(f"{old}.gml")
        path.rename(path.with_name(f"{new}.gml"))
        listing = path.parent / "_resources.list.xml"
        text = listing.read_text(encoding="utf-8")
        listing.write_text(
            text.replace(f'name="{old}"', f'name="{new}"'), encoding="utf-8"
        )


def add_script_group(out, group_name, scripts):
    group = out / "Scripts" / group_name
    group.mkdir()
    for name, code in scripts.items():
        (group / f"{name}.gml").write_text(code)
    (group / "_resources.list.xml").write_text(
        '<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n<resources>\n'
        + "".join(f'  <resource name="{n}" type="RESOURCE"/>\n' for n in scripts)
        + "</resources>\n"
    )
    top = out / "Scripts" / "_resources.list.xml"
    text = top.read_text(encoding="utf-8")
    top.write_text(
        text.replace(
            "<resources>\n",
            f'<resources>\n  <resource name="{group_name}" type="GROUP"/>\n',
            1,
        ),
        encoding="utf-8",
    )


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    ap.add_argument("src", type=Path)
    ap.add_argument("out", type=Path)
    ap.add_argument(
        "--stub-extensions",
        action="store_true",
        help="add return-0 scripts for native extensions",
    )
    args = ap.parse_args()

    if args.out.exists():
        shutil.rmtree(args.out)
    shutil.copytree(args.src, args.out)

    renames = dict(RENAMES)
    renames.update(SCRIPT_RENAMES)
    renames.update({name: helper for name, (helper, _) in HELPERS.items()})
    renames.update({f: "fct_" + f for f in FAUCET})
    rw = Rewriter(load_constants(args.out / "Constants.xml"), renames)

    problems = []
    for f in sorted(args.out.rglob("*.gml")):
        code = f.read_text(encoding="utf-8")
        lint(str(f.relative_to(args.out)), code, problems)
        f.write_text(rw.code(code), encoding="utf-8")

    def fix_tag(name, m):
        open_tag, body, close_tag = m.group(1, 2, 3) if m.group(1) else m.group(4, 5, 6)
        code = html.unescape(body)
        lint(name, code, problems)
        return open_tag + html.escape(rw.code(code), quote=False) + close_tag

    for f in sorted(args.out.rglob("*.xml")):
        if f.name == "Constants.xml":
            continue
        text = f.read_text(encoding="utf-8")
        name = str(f.relative_to(args.out))
        new = CODE_TAG_RE.sub(lambda m, name=name: fix_tag(name, m), text)
        if new != text:
            f.write_text(new, encoding="utf-8")

    if problems:
        print("prebuild: source has patterns ENIGMA mis-compiles:", file=sys.stderr)
        print("\n".join("  " + p for p in problems), file=sys.stderr)
        sys.exit(1)

    fill_empty_backgrounds(args.out)
    rename_rooms(args.out)
    rename_scripts(args.out, SCRIPT_RENAMES)
    add_script_group(args.out, "EnigmaHelpers", dict(HELPERS.values()))
    if args.stub_extensions:
        stub = "// stub: native extension not built yet\nreturn 0;\n"
        names = ["fct_" + f for f in FAUCET] + OTHER_EXTENSIONS
        add_script_group(args.out, "ExtensionStubs", dict.fromkeys(names, stub))


if __name__ == "__main__":
    main()
