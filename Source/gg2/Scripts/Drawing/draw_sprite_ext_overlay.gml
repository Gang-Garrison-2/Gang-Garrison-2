// void draw_sprite_ext_overlay(real sprite, real overlayList, real gearList, real subimg, real x, real y, real xscale, real yscale, real rot, real color, real alpha, real voffset)
// The same as draw_sprite_ext, except when overlay is not equal to -1 or gearList is not equal to -1
// the overlays will be drawn in-order on top of the sprite, using the same parameters
// then the gear will be drawn in-order on top of all that
// Having both overlay and gear in here is silly because gear is supposed to replace the overlay stuff, but someone still needs to actually do that.
// So supporting both is just a temporary cludge, which means it will probably remain here forever.
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

if(gearList != -1)
{
    if(!ds_list_empty(gearList))
    {
        var i, gearId, gearInfo, gearSpriteInfo, gearSpriteSubimageInfo, c, s, baseScaleOffX, baseScaleOffY, baseCenterPointX, baseCenterPointY;
        
        // Generally, you would expect that if you only scale and rotate, there is one point of the sprite which never moves in screen
        // coordinate space (the origin of the sprite). Game Maker decided that it would be a good idea to have different origins
        // for rotation and scaling. Rotation is around the pixel center of the screenspace draw position, while scaling is around
        // the upper left corner the sprite's origin pixel (in sprite coordinate space).
        // We need to compensate for that if we want to make the gear line up correctly with the base sprite under (almost) all conditions.
        // Unfortunately that is a bit complicated because we need to consider the rotation and scaling of both the base sprite and the
        // overlay in order to get the correct result.
        // tl;dr: Thanks Mark.
        
        c = cos(degtorad(_rot));
        s = sin(degtorad(_rot));
        
        // baseCenterPoint are the coordinates where the center position of the base sprite will appear on screen
        // (if sprite center coordinates are interpreted as falling on spritespace pixel centers)
        baseScaleOffX = (_xscale-1)/2;
        baseScaleOffY = (_yscale-1)/2;
        baseCenterPointX = _x + c*baseScaleOffX + s*baseScaleOffY;
        baseCenterPointY = _y + c*baseScaleOffY - s*baseScaleOffX;
        
        for(i=0; i<ds_list_size(gearList); i+=1)
        {
            gearId = ds_list_find_value(gearList, i);
            
            if(!ds_map_exists(global.gearOverlayInfo, gearId))
                continue;
            gearInfo = ds_map_find_value(global.gearOverlayInfo, gearId);
            
            if(!ds_map_exists(gearInfo, _sprite))
                continue;
            gearSpriteInfo = ds_map_find_value(gearInfo, _sprite);
            
            if(!ds_map_exists(gearSpriteInfo, round(_subimg)))
                continue;
            gearSpriteSubimageInfo = ds_map_find_value(gearSpriteInfo, round(_subimg));
            
            var overlaySprite, overlaySubimage, dx, dy, overlayAngle, overlayxscale, co, so, cg, sg, drawXScale, drawYScale, drawAngle, overlayScaleOffX, overlayScaleOffY, overlayCenterOffX, overlayCenterOffY;
            
            overlaySprite = ds_list_find_value(gearSpriteSubimageInfo, 0);
            overlaySubimage = ds_list_find_value(gearSpriteSubimageInfo, 1);
            dx = ds_list_find_value(gearSpriteSubimageInfo, 2) * _xscale;
            dy = ds_list_find_value(gearSpriteSubimageInfo, 3) * _yscale;
            overlayAngle = ds_list_find_value(gearSpriteSubimageInfo, 4);
            overlayxscale = ds_list_find_value(gearSpriteSubimageInfo, 5);
            
            // GM does not allow arbitrary linear transforms, so we cannot correctly draw the overlay
            // if it is at an oblique angle to the base sprite and there is arbitrary scaling involved.
            // The formula used here works correctly for non-oblique angles though.
            co = cos(degtorad(overlayAngle));
            so = sin(degtorad(overlayAngle));
            drawXScale = overlayxscale * (abs(co)*_xscale + abs(so)*_yscale);
            drawYScale = abs(so)*_xscale + abs(co)*_yscale;
            
            // Finally we need to compensate for the different center points of scaling and rotation, this time
            // for the drawing of the overlay
            drawAngle = _rot + overlayAngle;
            cg = cos(degtorad(drawAngle));
            sg = sin(degtorad(drawAngle));
            overlayScaleOffX = (drawXScale-1)/2;
            overlayScaleOffY = (drawYScale-1)/2;
            overlayCenterOffX = cg*overlayScaleOffX + sg*overlayScaleOffY;
            overlayCenterOffY = cg*overlayScaleOffY - sg*overlayScaleOffX;
            
            draw_sprite_ext(overlaySprite, overlaySubimage, baseCenterPointX + c*dx + s*dy - overlayCenterOffX, baseCenterPointY - s*dx + c*dy - overlayCenterOffY, drawXScale, drawYScale, drawAngle, _color, _alpha);
        }
    }
}
