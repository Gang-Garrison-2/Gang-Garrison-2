// gearSpecApply(gearSpec, gearName)

var gearSpec, gearName;

gearSpec = argument0;
gearName = argument1;

var basicAnimations;
basicAnimations = "Run,Stand,LeanL,LeanR,Jump,Taunt";

var class;
for(class = 0; class < 10; class += 1)
{
    var animations;
    switch(class)
    {
    case CLASS_SNIPER:
        animations = split(basicAnimations + ",Crouch", ",");
        break;
    case CLASS_HEAVY:
        animations = split(basicAnimations + ",Omnomnomnom,Walk", ",");
        break;
    case CLASS_QUOTE:
        animations = split(",Taunt", ",");
        break;
    case CLASS_SPY:
        animations = split(basicAnimations + ",BackstabTorso", ",");
        break;
    default:
        animations = split(basicAnimations, ",");
        break;
    }
    
    var team;
    for(team = 0; team <= 1; team += 1)
    {
        var animationNr;
        for(animationNr = 0; animationNr < ds_list_size(animations); animationNr += 1)
        {
            var animation, spriteId, headPoses;
            animation = ds_list_find_value(animations, animationNr);
            spriteId = getCharacterSpriteId(class, team, animation);
            
//          global.headPoseInfo: sprite -> subimage -> (dx, dy, angle, xscale)
            headPoses = ds_map_find_value(global.headPoseInfo, spriteId);
            
            var subimage;
            for(subimage = 0; subimage < sprite_get_number(spriteId); subimage += 1)
            {
                if(ds_map_exists(headPoses, subimage))
                {
                    var headPose, dx, dy, angle, xscale, overlaySprite, overlaySubimage, xoff, yoff, subimageScript, zindex;
                    headPose = ds_map_find_value(headPoses, subimage);
                    dx = ds_list_find_value(headPose, 0);
                    dy = ds_list_find_value(headPose, 1);
                    angle = ds_list_find_value(headPose, 2);
                    xscale = ds_list_find_value(headPose, 3);
                    
                    overlaySprite = _gearSpecGetWithDefaults(gearSpec, class, team, animation, subimage, "overlay", -1);
                    overlaySubimage = _gearSpecGetWithDefaults(gearSpec, class, team, animation, subimage, "overlaySubimage", -1);
                    xoff = _gearSpecGetWithDefaults(gearSpec, class, team, animation, subimage, "xoff", 0) * xscale;
                    yoff = _gearSpecGetWithDefaults(gearSpec, class, team, animation, subimage, "yoff", 0);
                    subimageScript = _gearSpecGetWithDefaults(gearSpec, class, team, animation, subimage, "subimageScript", 0);
                    zindex = _gearSpecGetWithDefaults(gearSpec, class, team, animation, subimage, "zindex", -20);
                    
                    if(overlaySprite >= 0 and overlaySubimage >= 0)
                    {
                        var c, s;
                        c = cos(degtorad(angle));
                        s = sin(degtorad(angle));
                        setGearOverlayInfo(spriteId, subimage, gearName, overlaySprite, overlaySubimage, dx + c*xoff + s*yoff, dy + c*yoff - s*xoff, angle, xscale, subimageScript, zindex);
                    }
                }
            }
        }
    }
    
    ds_list_destroy(animations);
}
