#!/usr/bin/env python3
"""Fix ENIGMA's generated C++ before it compiles (the g++ wrapper runs this
when SHELLmain.cpp, which includes the generated headers, is compiled).

Usage: fix_codegen.py <codegen dir>

#33: when an object defines some sub-events of a group (alarms, collisions),
ENIGMA generates a dispatcher override listing only the object's own
sub-events, so the ones inherited from the parent never fire (GG2: every
weapon's refire alarm, so no gun could shoot).
#35: self.<built-in> (hspeed, image_index, visible, ...) references an
accessor that isn't generated; use the glaccess form other.<built-in> gets.
#39: window settings from Global Game Settings (the GMK reader drops them).
Idempotent.
"""

import os
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

gen = Path(sys.argv[1]) / "Preprocessor_Environment_Editable"
decl = (gen / "IDE_EDIT_objectdeclarations.h").read_text()
func_path = gen / "IDE_EDIT_objectfunctionality.h"
func = func_path.read_text()
parent = dict(re.findall(r"struct OBJ_(\w+): OBJ_(\w+)", decl))


def ancestors(c):
    while c in parent:
        c = parent[c]
        yield c


# Alarms: rebuild each dispatcher from the union of its and its ancestors'.
ALARM_RE = re.compile(r"(void enigma::OBJ_(\w+)::myevent_alarm\(\) \{\n)(.*?)(\n\}\n)", re.S)
alarms = {m.group(2): set(map(int, re.findall(r"myevent_alarm_(\d+)_subcheck", m.group(3))))
          for m in ALARM_RE.finditer(func)}


def alarm_body(m):
    nums = set(alarms[m.group(2)])
    for a in ancestors(m.group(2)):
        nums |= alarms.get(a, set())
    body = "\n".join(f"  if (myevent_alarm_{n}_subcheck()) {{\n    myevent_alarm_{n}();\n  }}"
                     for n in sorted(nums, reverse=True))
    return m.group(1) + body + m.group(4)


func = ALARM_RE.sub(alarm_body, func)

# Collisions: chain to the nearest ancestor's dispatcher. Only safe when the
# two handle different objects; refuse otherwise so a new overlap is noticed.
COLL_RE = re.compile(r"(void enigma::OBJ_(\w+)::myevent_collision_dispatcher\(\) \{\n)(.*?)(\n\}\n)", re.S)
targets = {m.group(2): set(re.findall(r"^  if \(enigma::place_meeting_inst\(x, y, (\w+)\)\)", m.group(3), re.M))
           for m in COLL_RE.finditer(func)}


def coll_body(m):
    c, body = m.group(2), m.group(3)
    up = next((a for a in ancestors(c) if a in targets), None)
    call = f"  OBJ_{up}::myevent_collision_dispatcher();" if up else ""
    if not up or call in body:
        return m.group(0)
    if targets[c] & targets[up]:
        sys.exit(f"fix_codegen: {c} and {up} both handle {targets[c] & targets[up]}; merge by hand")
    return m.group(1) + body + "\n" + call + m.group(4)


func = COLL_RE.sub(coll_body, func)

# #35: `self.hspeed` (and the other motion built-ins) compiles to a
# varaccess_hspeed() that ENIGMA never generates; `other.hspeed` compiles to
# glaccess(...)->hspeed, which works. Use that form for self too.
# GM8 built-in instance variables (keep in sync with prebuild.BUILTINS).
BUILTINS = """x y xprevious yprevious xstart ystart hspeed vspeed direction speed
friction gravity gravity_direction alarm image_index image_speed image_xscale
image_yscale image_angle image_alpha image_blend image_number sprite_index
sprite_width sprite_height sprite_xoffset sprite_yoffset mask_index depth
visible solid persistent object_index bbox_left bbox_right bbox_top bbox_bottom
path_index path_position timeline_index id""".split()
defined = set(re.findall(r"varaccess_(\w+)\(int x\)", (gen / "IDE_EDIT_objectaccess.h").read_text()))
missing = [n for n in BUILTINS if n not in defined]
MOTION_RE = re.compile(r"enigma::varaccess_(%s)\(" % "|".join(missing)) if missing else None


def close(s, i):  # index of the ')' matching the '(' at s[i]
    depth = 0
    for j in range(i, len(s)):
        depth += {"(": 1, ")": -1}.get(s[j], 0)
        if depth == 0:
            return j
    sys.exit("fix_codegen: unbalanced parentheses")


out, pos = [], 0
while MOTION_RE and (m := MOTION_RE.search(func, pos)):
    end = close(func, m.end() - 1)
    out += [func[pos : m.start()], f"enigma::glaccess(int({func[m.end() : end]}))->{m.group(1)}"]
    pos = end + 1
func = "".join(out) + func[pos:]
if func != func_path.read_text():
    func_path.write_text(func)

# #39: emake's GMK reader drops Global Game Settings, so every window setting
# is generated as 0 (no border, not resizable, stretched). Take them from
# GmkSplitter's settings XML (env GAME_SETTINGS).
if settings_xml := os.environ.get("GAME_SETTINGS"):
    s = {e.tag: (e.text or "").strip() for e in ET.parse(settings_xml).iter()}
    rgb = int(s["colorOutsideRoom"], 16)
    values = {
        "interpolate_textures": s["interpolateColors"] == "true",
        "isSizeable": s["allowWindowResize"] == "true",
        "showBorder": s["dontDrawBorder"] != "true",
        "showIcons": s["dontShowButtons"] != "true",
        "freezeOnLoseFocus": s["freezeOnLoseFocus"] == "true",
        "treatCloseAsEscape": s["treatCloseAsEscape"] == "true",
        "isFullScreen": s["startFullscreen"] == "true",
        "viewScale": int(s["scalingPercent"]),
        "windowColor": (rgb & 0xFF) << 16 | (rgb & 0xFF00) | rgb >> 16,  # RGB -> GM BGR
    }
    glob_path = gen / "IDE_EDIT_globals.h"
    glob = glob_path.read_text()
    for name, v in values.items():
        glob, n = re.subn(rf"(\n  (?:bool|int) {name} = )[^;]*;", rf"\g<1>{int(v)};", glob)
        if n != 1:
            sys.exit(f"fix_codegen: {name} not found in IDE_EDIT_globals.h")
    if glob != glob_path.read_text():
        glob_path.write_text(glob)
