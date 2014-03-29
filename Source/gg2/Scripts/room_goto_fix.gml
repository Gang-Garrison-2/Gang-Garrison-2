{
    with(all) {
        if(not persistent) {
            instance_destroy();
        }
    }
    room_goto(argument0);
}