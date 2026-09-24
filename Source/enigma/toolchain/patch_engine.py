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
# Grow the far edge by one pixel (keeps each corner's colour).
GM8_RECT = ("    if (x2 >= x1) x2 += 1; else x1 += 1;\n"
            "    if (y2 >= y1) y2 += 1; else y1 += 1;\n")
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
        # #44: only the view viewports are cleared, and a resize clears one
        # buffer once, so letterbox bars show stale frames that flicker as the
        # buffers swap. GM8 fills the window with "colour outside the room".
        ("void screen_redraw()\n{\n  enigma::scene_begin();\n",
         "void screen_redraw()\n{\n  enigma::scene_begin();\n"
         "  graphics_set_viewport(0, 0, window_get_width(), window_get_height());\n"
         "  draw_clear(window_get_color());\n"
         # #45: GM8 stores view_x/yview/wview/hview as integers; ENIGMA keeps
         # fractions, so HUD drawn at view_xview + offset (GG2 kill log icons)
         # rounds differently each frame and wiggles.
         "  for (int i = 0; i < 8; i++) {\n"
         "    view_xview[i] = nearbyint((double) view_xview[i]); view_yview[i] = nearbyint((double) view_yview[i]);\n"
         "    view_wview[i] = nearbyint((double) view_wview[i]); view_hview[i] = nearbyint((double) view_hview[i]);\n"
         "  }\n", 1),
        ("using namespace std;\n",
         "using namespace std;\nnamespace enigma { extern bool redraw_refresh; }  // #42, defined by fix_codegen\n", 1),
        ("  screen_refresh();\n}", "  if (enigma::redraw_refresh) screen_refresh();\n}", 1),
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
    # #41: precise collision maps a pixel to the mask with (int)(pixel - x)
    # and (int)(d/scale + origin). GM8 rounds the instance position first and
    # floors the mask index; with a fractional position the mask lands one
    # pixel off (GG2 corpses, mines).
    "ENIGMAsystem/SHELL/Collision_Systems/Precise/PRECimpl.cpp": [
        *[(f"const int b{a}{n} = ({p} - {a}{n});", f"const int b{a}{n} = ({p} - (int)nearbyint({a}{n}));", c)
          for a, n, p, c in [("x", 1, "colindex", 3), ("y", 1, "rowindex", 3), ("x", 1, "gx", 2),
                             ("y", 1, "gy", 2), ("x", 2, "colindex", 1), ("y", 2, "rowindex", 1)]],
        *[(f"const int p{a}{n} = (int)((", f"const int p{a}{n} = (int)floor((", c)
          for a, n, c in [("x", 1, 5), ("y", 1, 5), ("x", 2, 1), ("y", 2, 1)]],
    ],
    # #42: screen_redraw() ends with a buffer swap, so a screen_save* after it
    # reads the undefined back buffer; the read also keeps the framebuffer's
    # alpha (mostly 0), and takes region coordinates as raw window pixels
    # (wrong area once the window is scaled/letterboxed). GG2's killcam
    # snapshot was black, then misaligned in fullscreen. Only the main loop's
    # redraw swaps (flag set by fix_codegen); captures map region coordinates
    # onto the window and come back at region resolution, opaque.
    "ENIGMAsystem/SHELL/Graphics_Systems/OpenGL-Desktop/screen.cpp": [
        ("  const int topY = enigma_user::window_get_region_height_scaled()-height-y;\n"
         "  unsigned char* pxdata = new unsigned char[width*height*bpp];\n",
         "  using namespace enigma_user;\n"
         "  const double sx = double(window_get_region_width_scaled()) / window_get_region_width(),\n"
         "               sy = double(window_get_region_height_scaled()) / window_get_region_height();\n"
         "  const int ox = (window_get_width() - window_get_region_width_scaled()) / 2,\n"
         "            oy = (window_get_height() - window_get_region_height_scaled()) / 2;\n"
         "  const int rw = width*sx < 1 ? 1 : int(width*sx + .5), rh = height*sy < 1 ? 1 : int(height*sy + .5);\n"
         "  const int rx = ox + int(x*sx + .5), ry = window_get_height() - (oy + int(y*sy + .5)) - rh;\n"
         "  unsigned char* raw = new unsigned char[rw*rh*bpp];\n"
         "  unsigned char* pxdata = new unsigned char[width*height*bpp];\n", 1),
        ("  glReadPixels(x,topY,width,height,GL_BGRA,GL_UNSIGNED_BYTE,pxdata);",
         "  glReadPixels(rx,ry,rw,rh,GL_BGRA,GL_UNSIGNED_BYTE,raw);\n"
         "  for (int j = 0; j < height; j++)  // nearest neighbour; rows stay bottom-up\n"
         "    for (int i = 0; i < width; i++) {\n"
         "      const int si = int(i*sx) < rw ? int(i*sx) : rw - 1, sj = int(j*sy) < rh ? int(j*sy) : rh - 1;\n"
         "      for (int c = 0; c < bpp; c++) pxdata[(j*width + i)*bpp + c] = raw[(sj*rw + si)*bpp + c];\n"
         "    }\n"
         "  delete[] raw;\n"
         "  for (int i = 3; i < width*height*bpp; i += bpp) pxdata[i] = 255;", 1),
    ],
    "ENIGMAsystem/SHELL/Graphics_Systems/OpenGL-Common/screen.cpp": [
        ("  const int fw = enigma_user::window_get_region_width_scaled(),\n"
         "            fh = enigma_user::window_get_region_height_scaled();",
         "  const int fw = enigma_user::window_get_region_width(),\n"
         "            fh = enigma_user::window_get_region_height();", 1),
    ],
    # #46: io_clear() leaves keyboard_lastkey/keyboard_key set; GM8 clears
    # them. GG2's key-binding menu calls io_clear() then binds the first
    # keyboard_lastkey, so it grabbed the previously pressed key at once.
    "ENIGMAsystem/SHELL/Platforms/General/PFwindow.cpp": [
        ("  for (int i = 0; i < 3; i++) enigma::mousestatus[i] = enigma::last_mousestatus[i] = 0;\n}",
         "  for (int i = 0; i < 3; i++) enigma::mousestatus[i] = enigma::last_mousestatus[i] = 0;\n"
         "  keyboard_lastkey = keyboard_key = 0;\n}", 1),
    ],
    # #40: a filled draw_rectangle covers pixels x1..x2-1; GM8 covers x1..x2
    # inclusive, so GG2's stacked menu rectangles left a 1px gap and its
    # 1px bezel rectangles drew nothing.
    "ENIGMAsystem/SHELL/Graphics_Systems/General/GSstdraw.cpp": [
        ("  } else {\n    draw_primitive_begin(pr_trianglestrip);\n    draw_vertex(x1, y1);\n    draw_vertex(x2, y1);",
         "  } else {\n" + GM8_RECT + "    draw_primitive_begin(pr_trianglestrip);\n    draw_vertex(x1, y1);\n    draw_vertex(x2, y1);", 1),
        ("  } else {\n    draw_primitive_begin(pr_trianglestrip);\n    draw_vertex_color(x2, y1, c2, alpha);",
         "  } else {\n" + GM8_RECT + "    draw_primitive_begin(pr_trianglestrip);\n    draw_vertex_color(x2, y1, c2, alpha);", 1),
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
