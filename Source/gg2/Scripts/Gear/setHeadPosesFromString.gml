// setHeadPosesFromString(spriteId, dxBase, dyBase, poseString);

var spriteId, dxBase, dyBase, poseString;
spriteId = argument0;
dxBase = argument1;
dyBase = argument2;
poseString = argument3;

var frames, i;
frames = split(poseString, "|");

for(i=0; i<ds_list_size(frames); i+=1)
{
    var dx_dy_angle_xscale, dx, dy, angle, xscale;
    dx_dy_angle_xscale = split(ds_list_find_value(frames, i), ",");
    dx = real(ds_list_find_value(dx_dy_angle_xscale, 0));
    dy = real(ds_list_find_value(dx_dy_angle_xscale, 1));
    
    if(ds_list_size(dx_dy_angle_xscale) > 2)
        angle = real(ds_list_find_value(dx_dy_angle_xscale, 2));
    else
        angle = 0;
        
    if(ds_list_size(dx_dy_angle_xscale) > 3)
        xscale = real(ds_list_find_value(dx_dy_angle_xscale, 3));
    else
        xscale = 1;
        
    ds_list_destroy(dx_dy_angle_xscale);
    setHeadPose(spriteId, i, dxBase+dx, dyBase+dy, angle, xscale);
}

ds_list_destroy(frames);

