/**
 * Set a player's ubercharge to ready
 *
 * argument0: The player who filled his ubercharge meter
 */

var uberer;
uberer = argument0;
 
if(uberer.object != -1) {
    playsound(uberer.object.x,uberer.object.y,UberChargedSnd);
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
