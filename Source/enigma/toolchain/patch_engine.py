#!/usr/bin/env python3
"""Patch ENIGMA engine bugs in the build-local engine copy (build.sh).

Usage: patch_engine.py <ENIGMA root> <engine copy>   apply patches
       patch_engine.py --files                        list patched files

Each patched file is excluded from build.sh's rsync and only rewritten when
its content changes, so make rebuilds just what depends on it. Each entry
names the ENIGMA bug (plans/enigma-bugs/ISSUES.md); drop it once fixed.
"""

import sys
from pathlib import Path

U = "ENIGMAsystem/SHELL/Universal_System/"
PATCHES = {
    # #26: variant bitwise ops bit-cast the double's IEEE bits (1.0 & 1 == 0);
    # master converts the value.
    U + "var4.h": [
        ("bit_cast<unsigned long long>(rval.d)", "(long long) rval.d", 5),
    ],
    # #23: sprite-font packing allocates and copies one byte per BGRA pixel.
    U + "Resources/fontstruct.cpp": [
        ("unsigned char* bigtex = new unsigned char[w*h]();",
         "unsigned char* bigtex = new unsigned char[w*h*4]();", 1),
        ("bigtex[w*(glyphmetrics[i].y + yy) + glyphmetrics[i].x + xx] = "
         "(glyphdata[i])[gtw*(glyphy[i] + yy) + xx + glyphx[i]];",
         "for (int channel = 0; channel < 4; ++channel)\n"
         "            bigtex[4*(w*(glyphmetrics[i].y + yy) + glyphmetrics[i].x + xx) + channel] = "
         "(glyphdata[i])[4*(gtw*(glyphy[i] + yy) + xx + glyphx[i]) + channel];", 1),
    ],
    # #27: background_replace leaves the room slots' background_width/height
    # at the old image's size (GM8 reads them live).
    U + "Resources/backgrounds.cpp": [
        ('#include "backgrounds_internal.h"',
         '#include "backgrounds_internal.h"\n#include "Universal_System/roomsystem.h"', 1),
        ("  return (backgrounds.replace(back, background_add_helper(filename, transparent, smooth, preload, mipmap)) != -1);",
         "  bool ok = backgrounds.replace(back, background_add_helper(filename, transparent, smooth, preload, mipmap)) != -1;\n"
         "  for (int i = 0; i < 8; i++)\n"
         "    if (int(background_index[i]) == back) {\n"
         "      background_width[i] = background_get_width(back);\n"
         "      background_height[i] = background_get_height(back);\n"
         "    }\n"
         "  return ok;", 1),
    ],
    # #28: GMK has no room-background alpha/colour; ENIGMA's GMK reader leaves
    # both 0, so every room background is invisible. GM8 draws them opaque and
    # untinted. ponytail: 0/0 is taken as "unset"; a genuinely invisible black
    # background can't be told apart (not expressible in GM8 anyway).
    U + "roomsystem.cpp": [
        ("      background_alpha[i] = backs[i].alpha;\n"
         "      background_coloring[i] = backs[i].color;",
         "      bool gmk_unset = backs[i].alpha == 0 && backs[i].color == 0;\n"
         "      background_alpha[i] = gmk_unset ? 1.0 : backs[i].alpha;\n"
         "      background_coloring[i] = gmk_unset ? 0xFFFFFF : backs[i].color;", 1),
    ],
    # #29: the temporary RawImage frees the pixel buffer, then every shape
    # generator delete[]s it again: double free on the first particle effect.
    U + "Extensions/ParticleSystems/PS_particle_sprites.cpp": [
        ("    unsigned texture = graphics_create_texture(RawImage(imgpxdata, width, height), false, &fullwidth, &fullheight);",
         "    RawImage img(imgpxdata, width, height);\n"
         "    unsigned texture = graphics_create_texture(img, false, &fullwidth, &fullheight);\n"
         "    img.pxdata = nullptr;  // the caller delete[]s imgpxdata", 1),
    ],
    # #30: GM8's 6-argument sprite_add(fname, imgnumb, removeback, smooth,
    # xorig, yorig) always builds precise masks; ENIGMA's overload passes
    # precise=false, so GG2's walkmask became one solid box over the map.
    U + "Resources/sprites.cpp": [
        ("  return sprite_add(filename, imgnumb, false, transparent, smooth, false, x_offset, y_offset, mipmap);",
         "  return sprite_add(filename, imgnumb, true, transparent, smooth, false, x_offset, y_offset, mipmap);", 1),
        ("  return sprite_replace(ind, filename, imgnumb, false, transparent, smooth, false, x_offset, y_offset, free_texture, mipmap);",
         "  return sprite_replace(ind, filename, imgnumb, true, transparent, smooth, false, x_offset, y_offset, free_texture, mipmap);", 1),
    ],
    # #31: the cursor sprite is drawn after switching to GUI (window-space)
    # projection, but at mouse_x/mouse_y, which are room coordinates: the
    # crosshair drifts by the view offset.
    "ENIGMAsystem/SHELL/Graphics_Systems/General/GSscreen.cpp": [
        # (#37) GUI units are the first room's size (screen_init), so map the
        # window mouse into them rather than assuming 1:1.
        ("    draw_sprite(cursor_sprite, 0, mouse_x, mouse_y);",
         "    draw_sprite(cursor_sprite, 0,\n"
         "      (window_mouse_get_x() - (window_get_width() - window_get_region_width_scaled()) / 2.0)\n"
         "        * enigma::gui_width / window_get_region_width_scaled(),\n"
         "      (window_mouse_get_y() - (window_get_height() - window_get_region_height_scaled()) / 2.0)\n"
         "        * enigma::gui_height / window_get_region_height_scaled());", 1),
    ],
    # #32: draw_background_ext/_general put the top-left corner at
    # (x - xscale, y - yscale) instead of (x, y): scaled backgrounds (GG2 maps,
    # 6x) draw 6 px up-left of the collision map.
    "ENIGMAsystem/SHELL/Graphics_Systems/General/GSbackground.cpp": [
        ("  gs_scalar ulcx = x + xscale * cos(M_PI+rot) + yscale * cos(M_PI/2+rot),\n"
         "            ulcy = y - yscale * sin(M_PI+rot) - yscale * sin(M_PI/2+rot);",
         "  gs_scalar ulcx = x, ulcy = y;", 2),
    ],
}

if sys.argv[1:] == ["--files"]:
    print("\n".join(PATCHES))
    sys.exit()
src, dst = map(Path, sys.argv[1:])
for rel, edits in PATCHES.items():
    text = (src / rel).read_text()
    for old, new, count in edits:
        if text.count(old) != count:
            sys.exit(f"patch_engine: {rel}: matched {text.count(old)}x, expected {count}: {old[:60]}")
        text = text.replace(old, new)
    out = dst / rel
    if not out.exists() or out.read_text() != text:
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text)
