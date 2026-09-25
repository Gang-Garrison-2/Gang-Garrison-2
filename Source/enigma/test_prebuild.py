#!/usr/bin/env python3
"""Self-check for prebuild.py's rewrites: python3 test_prebuild.py"""

import prebuild as p

rw = p.Rewriter({"read_ubyte": "fct_read_ubyte"})


def check(src, expected):
    got = rw.code(src)
    assert got == expected, f"\n  in:  {src!r}\n  got: {got!r}\n  exp: {expected!r}"


# renames outside strings and comments only
check('read_ubyte(b); s = "read_ubyte"; // read_ubyte', 'fct_read_ubyte(b); s = "read_ubyte"; // read_ubyte')
check("x = read_ubyte(b); y = my_read_ubyte;", "x = fct_read_ubyte(b); y = my_read_ubyte;")

print("prebuild self-check OK")
