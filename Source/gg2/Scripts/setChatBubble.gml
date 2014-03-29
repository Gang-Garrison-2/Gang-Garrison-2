if(instance_exists(argument0)) {
    if(argument0.object != -1) {
        argument0.object.bubbleImage=argument1;
        argument0.object.alarm[0] = 60;
        argument0.object.bubbleAlpha = 1;
        argument0.object.bubbleFadeout = false;
    }
}