/**
 * Start a prepared ubercharge
 *
 * argument0: The player who wants to ubercharge
 */
 
var uberer;
uberer = argument0;
                    
if(uberer.object != -1) {
    playsound(uberer.object.x,uberer.object.y,UberStartSnd);
    with(Medigun) {
        if(ownerPlayer == uberer) {
            ubering = true;
            uberReady = false;
        }
    }
} else {
    show_message("The Uber-Event has just been called for a dead player. Please report this bug.");
}