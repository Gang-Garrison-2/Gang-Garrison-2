/**
 * Set a player's ubercharge to ready
 *
 * argument0: The player who filled his ubercharge meter
 */

var uberer;
uberer = argument0;
 
if(uberer.object != -1) {
    UberChargedSnd = faudio_new_generator(UberChargedSndS);
    playsound(uberer.object.x,uberer.object.y,UberChargedSnd);
    faudio_kill_generator(UberChargedSnd);
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
