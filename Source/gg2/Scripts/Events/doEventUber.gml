/**
 * Start a prepared ubercharge
 *
 * argument0: The player who wants to ubercharge
 */
 
var uberer;
uberer = argument0;
                    
if(uberer.object != -1) {
    // TODO(enigma): temp var avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
    var ubererObject;
    ubererObject = uberer.object;
    playsound(ubererObject.x,ubererObject.y,UberStartSnd);
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
