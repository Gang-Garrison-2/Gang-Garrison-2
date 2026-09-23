#!/usr/bin/env python3
"""Prepare a copy of the GG2 source tree for ENIGMA.

Stopgap for ENIGMA bugs that can be fixed with a text rewrite. The repo source
stays valid GM8; the rewritten copy is only for ENIGMA builds. Each workaround
names the ENIGMA bug it covers; delete it once that bug is fixed upstream.

Bugs that need a structural rewrite (nested built-in dot access, string
switch) are fixed in the source, marked TODO(enigma). This script lints for
them so they don't come back.

Usage: prebuild.py <Source/gg2> <out dir> [--stub-extensions] [--headless]
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
    # ENIGMA declares these but no widget system implements them.
    # ponytail: approximated with question/number prompts; proper fix is a
    # zenity --list/--question implementation in ENIGMA's xlib widgets.
    "show_message_ext": (
        "gml_show_message_ext",
        "var n, choice, text;\n"
        "n = 0;\n"
        'text = argument0 + "##";\n'
        'if (argument1 != "") { n += 1; choice[n] = 1;'
        ' text += string(n) + ": " + argument1 + "#"; }\n'
        'if (argument2 != "") { n += 1; choice[n] = 2;'
        ' text += string(n) + ": " + argument2 + "#"; }\n'
        'if (argument3 != "") { n += 1; choice[n] = 3;'
        ' text += string(n) + ": " + argument3 + "#"; }\n'
        "if (n == 0) { show_message(argument0); return 0; }\n"
        "if (n == 1) { show_message(argument0); return choice[1]; }\n"
        "if (n == 2) {\n"
        '    if (show_question(argument0 + "##Yes: " + argument1 + "#No: "'
        " + argument3)) return choice[1];\n"
        "    return choice[2];\n"
        "}\n"
        "n = get_integer(text, 1);\n"
        "if (n < 1 or n > 3) return 0;\n"
        "return choice[n];\n",
    ),
    "show_menu_pos": (
        "gml_show_menu_pos",
        "var rest, text, n, p;\n"
        'rest = argument2; text = "Choose:#"; n = 0;\n'
        'while (rest != "") {\n'
        '    p = string_pos("|", rest);\n'
        "    if (p == 0) p = string_length(rest) + 1;\n"
        "    n += 1;\n"
        '    text += string(n) + ": " + string_copy(rest, 1, p - 1) + "#";\n'
        "    rest = string_delete(rest, 1, p);\n"
        "}\n"
        "p = get_integer(text, 0);\n"
        "if (p < 1 or p > n) return argument3;\n"
        "return p - 1;\n",
    ),
}

# GM8 functions ENIGMA doesn't have, added as scripts of the same name.
COMPAT = {
    # Message box styling: cosmetic, ENIGMA uses native dialogs.
    **dict.fromkeys(
        [
            "message_background",
            "message_button",
            "message_text_font",
            "message_button_font",
            "message_input_font",
        ],
        "// no-op: ENIGMA uses native dialogs\n",
    ),
    # GM8 splash windows: open the page in the browser instead.
    "action_splash_web": "url_open(argument0);\n",
    # Pass-through for wrap_script_locals (not a GM8 function).
    "gml_value": "return argument0;\n",
    "splash_show_web": "url_open(argument0);\n",
    "splash_set_main": "// no-op: no splash window\n",
    "splash_set_interrupt": "// no-op: no splash window\n",
    # Included files are shipped next to the binary instead of embedded.
    "export_include_file_location": "return file_copy(program_directory + "
    '"/" + argument0, argument1);\n',
}

# Extension stubs that need a non-zero result to fail cleanly.
STUB_OVERRIDES = {
    "upnp_error_string": 'return "UPnP port forwarding is not supported in this'
    ' build.";\n',
}

# Headless builds: no file dialogs (ask on the console), and no sprite pixel
# data under graphics None, so fonts can't be built from sprites (crashes in
# ENIGMA's font_pack). Nothing is drawn anyway.
HEADLESS_HELPERS = {
    "font_add_sprite": ("gml_font_add_sprite", "return -1;\n"),
    "get_open_filename": (
        "gml_get_open_filename",
        'return get_string("File to open:", "");\n',
    ),
    "get_save_filename": (
        "gml_get_save_filename",
        'return get_string("File to save:", argument1);\n',
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

    def code(self, text, is_script=False):
        # ENIGMA bug: `var` is block-scoped (C++), but function-scoped in GML, so
        # a var declared in one branch and used in another is undeclared. Hoist
        # every declaration to the top of the script/event.
        names = []

        def hoist(m):
            names.extend(re.split(r"\s*,\s*", m.group(1)))
            return "\n" * m.group(0).count("\n")  # keep line numbers

        out, last = [], 0
        for m in SKIP_RE.finditer(text):
            plain = VAR_RE.sub(hoist, self.plain(text[last : m.start()]))
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
        out.append(VAR_RE.sub(hoist, self.plain(text[last:])))
        body = "".join(out)
        if not names:
            return body
        if is_script:
            body = wrap_script_locals(body, set(names))
        return "var " + ", ".join(dict.fromkeys(names)) + "; " + body

    def plain(self, text):
        for rx, rep in self.rewrites:
            text = rx.sub(rep, text)
        return text


PLUS_ONLY_RE = re.compile(r"\s*\+\s*")
TOKEN_RE = re.compile(r"[A-Za-z_]\w*|\d+(?:\.\d+)?|\$[0-9A-Fa-f]+|\S")
# Keywords after which ( or a bare name is not a function call or operand.
CONTROL_KW = {"return", "if", "while", "until", "repeat", "with", "switch"}
OPERATOR_KW = CONTROL_KW | {"and", "or", "xor", "not", "div", "mod", "case"}
OPERATOR_TOKENS = set("=(,[!+-*/%<>&|^~?:{};")


def wrap_script_locals(body, local_names):
    """ENIGMA bug: in scripts, a `var` local that stands alone in some positions
    is compiled as a read of the instance variable of that name: `(x)`, `-x`,
    `!x`, `if (x)`, `return x`, ... Binary operands, assignments and call
    arguments compile correctly, so route the bad positions through a call."""
    out, last = [], 0
    for m in SKIP_RE.finditer(body):
        out += [_wrap_segment(body[last : m.start()], local_names), m.group(0)]
        last = m.end()
    out.append(_wrap_segment(body[last:], local_names))
    return "".join(out)


def _wrap_segment(seg, local_names):
    toks = list(TOKEN_RE.finditer(seg))
    text = [t.group(0) for t in toks]

    def at(i):
        return text[i] if 0 <= i < len(text) else None

    def operand_start(tok):  # nothing to the left binds as a binary operand
        return tok is None or tok in OPERATOR_TOKENS or tok in OPERATOR_KW

    spans = []
    for i, name in enumerate(text):
        if name not in local_names or at(i + 1) in ("[", "(", "."):
            continue
        prev, prev2 = at(i - 1), at(i - 2)
        if (
            (prev == "(" and at(i + 1) == ")" and operand_start(prev2))
            or prev in ("!", "~")
            or (prev in ("-", "+") and operand_start(prev2))
            or prev in CONTROL_KW
        ):
            spans.append(toks[i].span())
    for a, b in reversed(spans):
        seg = f"{seg[:a]}gml_value({seg[a:b]}){seg[b:]}"
    return seg


# GM8 var statements have no initializers; the ; is optional.
VAR_RE = re.compile(r"\bvar\s+(\w+(?:\s*,\s*\w+)*)\s*;?")


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


def fill_empty_sprites(out):
    # ENIGMA bug: a sprite with no subimages stops the resource writer, and the
    # game ships without any resources (emake still reports success). GM8 uses
    # such sprites as never-colliding masks; a fully transparent 1x1 image with
    # a precise mask keeps that behavior.
    for xml in (out / "Sprites").rglob("*.xml"):
        if xml.name == "_resources.list.xml":
            continue
        images = xml.with_suffix(".images")
        if images.is_dir() and any(images.glob("image *.png")):
            continue
        images.mkdir(exist_ok=True)
        (images / "image 0.png").write_bytes(placeholder_png())
        text = xml.read_text(encoding="utf-8")
        xml.write_text(
            re.sub(r"<shape>\w+</shape>", "<shape>PRECISE</shape>", text),
            encoding="utf-8",
        )


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
    ap.add_argument("--headless", action="store_true", help="build for widgets None")
    args = ap.parse_args()
    helpers = HELPERS | (HEADLESS_HELPERS if args.headless else {})

    if args.out.exists():
        shutil.rmtree(args.out)
    shutil.copytree(args.src, args.out)

    renames = dict(RENAMES)
    renames.update(SCRIPT_RENAMES)
    renames.update({name: helper for name, (helper, _) in helpers.items()})
    renames.update({f: "fct_" + f for f in FAUCET})
    rw = Rewriter(load_constants(args.out / "Constants.xml"), renames)

    problems = []
    for f in sorted(args.out.rglob("*.gml")):
        code = f.read_text(encoding="utf-8")
        lint(str(f.relative_to(args.out)), code, problems)
        f.write_text(rw.code(code, is_script=True), encoding="utf-8")

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
    fill_empty_sprites(args.out)
    rename_rooms(args.out)
    rename_scripts(args.out, SCRIPT_RENAMES)
    add_script_group(args.out, "EnigmaHelpers", dict(helpers.values()) | COMPAT)
    if args.stub_extensions:
        stub = "// stub: native extension not built yet\nreturn 0;\n"
        names = ["fct_" + f for f in FAUCET] + OTHER_EXTENSIONS
        stubs = dict.fromkeys(names, stub) | STUB_OVERRIDES
        add_script_group(args.out, "ExtensionStubs", stubs)


if __name__ == "__main__":
    main()
