// void draw_sprite_ext_overlay(real sprite, real overlayList, real subimg, real x, real y, real xscale, real yscale, real rot, real color, real alpha, real voffset)
// The same as draw_sprite_ext, except when overlay is not equal to -1,
// the overlays will be drawn in-order on top of the sprite, using the same parameters
var _sprite,
    overlayList,
    gearList,
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
gearList = argument2;
_subimg = argument3;
_x = argument4;
_y = argument5;
_xscale = argument6;
_yscale = argument7;
_rot = argument8;
_color = argument9;
_alpha = argument10;
_voffset = argument11;

_subimg = floor(_subimg) mod sprite_get_number(_sprite);
if(_subimg < 0)
    _subimg += sprite_get_number(_sprite);

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

var i, gearId, gearInfo, gearSpriteInfo, gearSpriteSubimageInfo;

for(i=0; i<ds_list_size(gearList); i+=1)
{
    gearId = ds_list_find_value(gearList, i);
    
    if(!ds_map_exists(global.gearOverlayInfo, gearId))
    {
        show_message("gear ID not found");
        continue;
    }
    gearInfo = ds_map_find_value(global.gearOverlayInfo, gearId);
    
    if(!ds_map_exists(gearInfo, _sprite))
    {
        show_message("sprite not found");
        continue;
    }
    gearSpriteInfo = ds_map_find_value(gearInfo, _sprite);
    
    if(!ds_map_exists(gearSpriteInfo, round(_subimg)))
    {
        show_message("subimage not found");
        continue;
    }
    gearSpriteSubimageInfo = ds_map_find_value(gearSpriteInfo, round(_subimg));
    
    var overlaySprite, overlaySubimage, dx, dy, overlayAngle, overlayxscale;
    
    overlaySprite = ds_list_find_value(gearSpriteSubimageInfo, 0);
    overlaySubimage = ds_list_find_value(gearSpriteSubimageInfo, 1);
    dx = ds_list_find_value(gearSpriteSubimageInfo, 2) * _xscale;
    dy = ds_list_find_value(gearSpriteSubimageInfo, 3) * _yscale;
    overlayAngle = ds_list_find_value(gearSpriteSubimageInfo, 4);
    overlayxscale = ds_list_find_value(gearSpriteSubimageInfo, 5);
    
    draw_sprite_ext(overlaySprite, overlaySubimage, _x + cos(_rot)*dx + sin(_rot)*dy, _y + sin(_rot)*dx + cos(_rot)*dy, _xscale*overlayxscale, _yscale, _rot + overlayAngle, _color, _alpha);
}
