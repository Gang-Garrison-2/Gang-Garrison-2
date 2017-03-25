// setHeadPose(sprite, subimage, dx, dy, angle, xscale)
// Helper to set the head pose for a character animation frame.
// This information tracks a fixed point on the head of each character. Head gear will be attached to that point.
// xscale=-1 is used to signify that the head is facing the opposite way in this image, so the attached gear will be flipped.
// The dx and dy positions are relative to the sprite's origin.

// Note that this technique creates quite a few data structures that won't be cleaned up again until the end of the program.
// However, GM8 seems to handle tens of thousands of data structures just fine and without catastrophic memory overhead.

// The data structure is global.headPoseInfo: sprite -> subimage -> (dx, dy, angle, xscale)
var sprite, subimage, dx, dy, angle, xscale;

sprite = argument0;
subimage = argument1;
dx = argument2;
dy = argument3;
angle = argument4;
xscale = argument5;

if(!variable_global_exists("headPoseInfo"))
    global.headPoseInfo = ds_map_create();

var subimageMap;
if(ds_map_exists(global.headPoseInfo, sprite))
{
    subimageMap = ds_map_find_value(global.headPoseInfo, sprite);
}
else
{
    subimageMap = ds_map_create();
    ds_map_add(global.headPoseInfo, sprite, subimageMap);
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

ds_list_add(frameInfo, dx);
ds_list_add(frameInfo, dy);
ds_list_add(frameInfo, angle);
ds_list_add(frameInfo, xscale);
