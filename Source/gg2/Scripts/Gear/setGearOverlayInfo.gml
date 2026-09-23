// Helper to set the gear overlay information for a single sprite frame.
// setGearOverlayInfo(sprite, subimage, gear, overlaySprite, overlaySubimage, dx, dy, angle, xscale)

var sprite, subimage, gear, overlaySprite, overlaySubimage, dx, dy, angle, xscale;

sprite = argument0;
subimage = argument1;
gear = argument2;
overlaySprite = argument3;
overlaySubimage = argument4;
dx = argument5;
dy = argument6;
angle = argument7;
xscale = argument8;
subimageSelectionScript = argument9;
zindex = argument10;

if(!variable_global_exists("gearOverlayInfo"))
    global.gearOverlayInfo = ds_map_create();
    
var spriteMap;
if(ds_map_exists(global.gearOverlayInfo, gear))
{
    spriteMap = ds_map_find_value(global.gearOverlayInfo, gear);
}
else
{
    spriteMap = ds_map_create();
    ds_map_add(global.gearOverlayInfo, gear, spriteMap);
}

var subimageMap;
if(ds_map_exists(spriteMap, sprite))
{
    subimageMap = ds_map_find_value(spriteMap, sprite);
}
else
{
    subimageMap = ds_map_create();
    ds_map_add(spriteMap, sprite, subimageMap);
}

var frameInfo;
if(ds_map_exists(subimageMap, subimage))
{
    frameInfo = ds_map_find_value(subimageMap, subimage);
    ds_list_clear(frameInfo);
}
else
{
    frameInfo = ds_list_create();
    ds_map_add(subimageMap, subimage, frameInfo);
}

ds_list_add(frameInfo, overlaySprite);
ds_list_add(frameInfo, overlaySubimage);
ds_list_add(frameInfo, dx);
ds_list_add(frameInfo, dy);
ds_list_add(frameInfo, angle);
ds_list_add(frameInfo, xscale);
ds_list_add(frameInfo, subimageSelectionScript);
ds_list_add(frameInfo, zindex);
