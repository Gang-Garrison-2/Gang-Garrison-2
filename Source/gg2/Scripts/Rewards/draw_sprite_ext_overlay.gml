// void draw_sprite_ext_overlay(real sprite, real overlay, real subimg, real x, real y, real xscale, real yscale, real rot, real color, real alpha)
// The same as draw_sprite_ext, except when overlay is not equal to -1,
// the overlay will be drawn on top of the sprite with the same parameters
var _sprite,
    overlay,
    _subimg,
    _x,
    _y,
    _xscale,
    _yscale,
    _rot,
    _color,
    _alpha,
    _voffset;
_sprite = argument0;
overlay = argument1;
_subimg = argument2;
_x = argument3;
_y = argument4;
_xscale = argument5;
_yscale = argument6;
_rot = argument7;
_color = argument8;
_alpha = argument9;
_voffset = argument10;

draw_sprite_ext(_sprite, _subimg, _x, _y, _xscale, _yscale, _rot, _color, _alpha);
if (overlay != -1)
    draw_sprite_ext(overlay, _subimg, _x, _y+_voffset, _xscale, _yscale, _rot, _color, _alpha);
