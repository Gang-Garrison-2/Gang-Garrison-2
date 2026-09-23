if(instance_exists(argument0)) {
    if(argument0.object != -1) {
        // TODO(enigma): temp var avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
        var chatBubble;
        chatBubble = argument0.object.bubble;
        chatBubble.image_index = argument1;
        chatBubble.alarm[0] = 60 / global.delta_factor;
        chatBubble.visible = true;
        chatBubble.bubbleAlpha = 1;
        chatBubble.fadeout = false;
    }
}
