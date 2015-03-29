// void draw_sprite_ext_overlay(real sprite, real overlayList, real subimg, real x, real y, real xscale, real yscale, real rot, real color, real alpha, real voffset)
// The same as draw_sprite_ext, except when overlay is not equal to -1,
// the overlays will be drawn in-order on top of the sprite, using the same parameters
var _sprite,
    overlayList,
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
overlayList = argument1;
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
if (overlayList != -1)
{
    if (!ds_list_empty(overlayList))
    {
        for(i = 0; i < ds_list_size(overlayList); i+=1)
        {
            draw_sprite_ext(ds_list_find_value(overlayList,i), _subimg, _x, _y+_voffset, _xscale, _yscale, _rot, _color, _alpha);
        }
    }
}
