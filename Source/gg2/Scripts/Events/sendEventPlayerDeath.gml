/**
 * Notify all clients of a "player death" event.
 *
 * argument0: The player whose character died
 * argument1: The player who inflicted the fatal damage (or -1 for unknown)
 * argument2: The assistant (or -1 for none)
 * argument3: The source of the fatal damage
 */
var victim, killer, assistant, damageSource;
victim = argument0;
killer = argument1;
assistant = argument2;
damageSource = argument3;

writebyte(PLAYER_DEATH, global.eventBuffer);
writebyte(ds_list_find_index(global.players, victim), global.eventBuffer);
if(killer != -1) {
    writebyte(ds_list_find_index(global.players, killer), global.eventBuffer);
} else {
    writebyte(255, global.eventBuffer);
}
if(assistant != -1) {
    writebyte(ds_list_find_index(global.players, assistant), global.eventBuffer);
} else {
    writebyte(255, global.eventBuffer);
}  
writebyte(damageSource, global.eventBuffer);
