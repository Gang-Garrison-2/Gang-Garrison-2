#!/usr/bin/env python3
"""Self-check for prebuild.py's rewrites: python3 test_prebuild.py"""

import prebuild as p

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

# lint: nested built-in dot, dot after call, string switch
problems = []
p.lint("t", 'x = a.b.x; y = f().y; z = a.x; switch (s) { case "q": break; }', problems)
assert len(problems) == 3, problems

print("prebuild self-check OK")
