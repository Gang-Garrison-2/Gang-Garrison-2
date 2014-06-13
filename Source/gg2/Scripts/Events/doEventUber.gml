/**
 * Start a prepared ubercharge
 *
 * argument0: The player who wants to ubercharge
 */
 
var uberer;
uberer = argument0;
                    
if(uberer.object != -1) {
    UberStartSnd = faudio_new_generator(UberStartSndS);
    playsound(uberer.object.x,uberer.object.y,UberStartSnd);
    faudio_kill_generator(UberStartSnd);
    with(uberer.object.currentWeapon) {
        ubering = true;
        uberReady = false;
        uberer.stats[INVULNS] += 1;
        uberer.roundStats[INVULNS] += 1;
        uberer.stats[POINTS] += 1;
        uberer.roundStats[POINTS] += 1;
    }
} else {
    show_message("The Uber-Event has just been called for a dead player. Please report this bug.");
}
