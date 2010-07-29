if(instance_exists(argument0)) {
    if(argument0.object != -1) {
        argument0.object.bubble.image_index = argument1;
        argument0.object.bubble.alarm[0] = 60;
        argument0.object.bubble.visible = true;
        argument0.object.bubble.bubbleAlpha = 1;
        argument0.object.bubble.fadeout = false;
    }
}