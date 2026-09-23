/**
 * Set a player's ubercharge to ready
 *
 * argument0: The player who filled his ubercharge meter
 */

var uberer;
uberer = argument0;
 
if(uberer.object != -1) {
    // TODO(enigma): temp var avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
    var ubererObject;
    ubererObject = uberer.object;
    playsound(ubererObject.x,ubererObject.y,UberChargedSnd);
    setChatBubble(uberer, 46);
    with(Medigun) {
        if(ownerPlayer == uberer) {
            uberReady = true;
            uberCharge = 2000;
        }
    }
} else {
    show_message("The UberReady-Event has just been called for a dead player. Please report this bug.");
}
