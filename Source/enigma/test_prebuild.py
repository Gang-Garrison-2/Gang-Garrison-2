#!/usr/bin/env python3
"""Self-check for prebuild.py's rewrites: python3 test_prebuild.py"""

import prebuild as p
from pathlib import Path

rw = p.Rewriter({"K": "3", "S": '"txt"'}, {"char": "char_", "zz": "yy"})


def check(src, expected, is_script=False):
    got = rw.code(src, is_script)
    assert got == expected, f"\n  in:  {src!r}\n  got: {got!r}\n  exp: {expected!r}"


# constants inlined, strings and comments untouched
check('x = K; s = "K"; // K', 'x = 3; s = "K"; // K')
# renames, not -> !, exit braces, trailing ; in for
check("char = 1;", "char_ = 1;")
check("if not done exit; else x = 1;", "if !done { exit; } else x = 1;")
check("for (i = 0; i < 3; i += 1;) {}", "for (i = 0; i < 3; i += 1) {}")
# literal concatenation merged, mixed operands kept
check('x = "a" + "b" + y;', 'x = "ab" + y;')
check('x = y + "a" + "b";', 'x = y + "ab";')
check('x = "a" + y + "b";', 'x = "a" + y + "b";')
# globalvar names become global.name, except in the declaration
gw = p.Rewriter({"K": "3"}, {"zz": "yy"}, {"DS_A", "G"})
got = gw.code("globalvar DS_A,\n    G;\nx = DS_A; y = other.G; G[0] = 1;")
assert got == "globalvar DS_A,\n    G;\nx = global.DS_A; y = other.G; global.G[0] = 1;", got

# GM8 precedence: bitwise binds tighter than comparison
check("if(s & $01 != 0) x = (t & 1 == 1);", "if((s & $01) != 0) x = ((t & 1) == 1);")
check("if(a && b & 2 > 0 or c | d <= e) {}", "if(a && (b & 2) > 0 or (c | d) <= e) {}")
check("if(!c | d <= e) {}", "if(!c | d <= e) {}")  # unary operand: left to lint
check("if(k & $40 and h >= 0) {}", "if(k & $40 and h >= 0) {}")
# var hoisting keeps line count
check(
    "a = 1;\nif (c) {\n    var i;\n    i = 2;\n}",
    "var i; a = 1;\nif (c) {\n    \n    i = 2;\n}",
)
# script locals in positions ENIGMA misresolves, only in scripts
check(
    "var a; x = -a; y = (a); if (a) z = 1; w = b - a; v = f(a); return a;",
    "var a;  x = -gml_value(a); y = (gml_value(a)); if (gml_value(a)) z = 1; "
    "w = b - a; v = f(a); return gml_value(a);",
    is_script=True,
)
check("var a; if (a) x = -a;", "var a;  if (a) x = -a;")
check(
    "var i; for (i = 0; i < 3; i += 1) x = ds_map_find_value(m, string(i));",
    "var i;  for (i = 0; i < 3; i += 1) x = ds_map_find_value(m, string(gml_value(i)));",
    is_script=True,
)

# lint: nested built-in dot, dot after call, string switch
problems = []
p.lint("t", 'x = a.b.x; y = f().y; z = a.x; switch (s) { case "q": break; }', problems)
assert len(problems) == 3, problems
# lint: sibling reads of one stream (C++ operand order); nested and cross-buffer ok
problems = []
p.lint("t", "f(p, read_ubyte(b), read_ubyte(b));", problems)
p.lint("t", "s = read_string(b, read_ubyte(b)); if (read_uint(b) != read_uint(u)) x = 1;", problems)
p.lint("t", "repeat (read_ushort(b)) if (read_ubyte(u) != read_ubyte(b)) x = 1;", problems)
assert len(problems) == 1, problems
# lint: bitwise/comparison mix the rewrite can't group
problems = []
p.lint("t", "if (s & $01 != 0 and x | y + 1 == 2) z = 1; if (k & $40 and h >= 0) z = 2;", problems)
p.lint("t", "if (!c | d <= e) z = 1;", problems)
assert len(problems) == 2 and all("bitwise" in q for q in problems), problems

# lint: && and || mixed at one paren level (GM8: equal precedence)
problems = []
p.lint("t", "if (a || b and c) x = 1; if ((a || b) && c) x = 2; f(a && b, c or d); x = a or b; y = c and d;", problems)
p.lint("t", "if a == 1 or b != 2 and c < 3 z = 1;", problems)
assert len(problems) == 2 and all("mixed" in q for q in problems), problems

# with() bodies in object events: names the enclosing object owns get self.
got = p.qualify_with_bodies(
    "var d; with (Character) { if (dist(other) < other.r) hp -= 999; d = x; foo(team); }\n"
    "with (Rocket) instance_destroy(); y = 1;\n"
    "with (a) if (b) {\n  x = 1;\n}\nx = 2;",
    {"hp", "x", "y", "team", "d", "b"},
)
assert got == (
    "var d; with (Character) { if (dist(other) < other.r) self.hp -= 999; d = self.x; foo(self.team); }\n"
    "with (Rocket) instance_destroy(); y = 1;\n"
    "with (a) if (self.b) {\n  self.x = 1;\n}\nx = 2;"
), got

# GM8 Inherited D&D actions must enter ENIGMA as GML parent-event calls.
source = Path(__file__).resolve().parent.parent / "gg2/Objects"
draw = source / "Menus/Main Menu Elements/MainMenuController.events/Draw.xml"
converted = p.convert_inherited_actions(draw.read_text())
assert "<functionName>action_inherited</functionName>" not in converted
assert "event_inherited();</argument>" in converted
end_step = source / "Weapons/Flamethrower.events/End Step.xml"
converted = p.convert_inherited_actions(end_step.read_text())
assert "<functionName>action_inherited</functionName>" not in converted
assert '<argument kind="STRING">event_inherited();\n' in converted

print("prebuild self-check OK")
