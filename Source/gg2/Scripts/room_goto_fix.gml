/*
 * Together with the RoomChangeObserver object, this script enables the following behaviour:
 * If you consistently use room_goto_fix instead of room_goto, all instances that are removed from the game
 * because of the room change will have their Destroy event called. Also, all instances that are added to
 * the game as part of a room change will have their Create events called.
 * If this script is called while a room change is already in progress, the new change will be delayed until
 * the running change is completed.
 *
 * This has not been tested much and might cause problems with things like persistent rooms.
 */

if(!instance_exists(RateController))
    instance_create(0, 0, RateController);

if(!global.fullscreen)
{
    previous_window_x = window_get_x();
    previous_window_y = window_get_y();
    previous_window_w = window_get_width();
}
if(global.changed_resolution)
{
    rooms_fix_views();
    global.changed_resolution = false;
}

if(not instance_exists(RoomChangeObserver)) {
    instance_create(0,0,RoomChangeObserver);
}

if(RoomChangeObserver.transitioning)
{
    RoomChangeObserver.nextRoom = argument0;
}
else
{
    if(not room_persistent)
    {
        with(all)
        {
            if(not persistent)
                instance_destroy();
        }
    }
    RoomChangeObserver.transitioning = true;
    room_goto(argument0);
}
