/**
 * Notify all clients of a "player death" event.
 *
 * argument0: The player whose character died
 * argument1: The player who inflicted the fatal damage (or -1 for unknown)
 * argument2: The source of the fatal damage
 */
var victim, killer, damageSource;
victim = argument0;
killer = argument1;
damageSource = argument2;

writebyte(PLAYER_DEATH, global.eventBuffer);
writebyte(ds_list_find_index(global.players, victim), global.eventBuffer);
if(killer != -1) {
    writebyte(ds_list_find_index(global.players, killer), global.eventBuffer);
} else {
    writebyte(255, global.eventBuffer);
}
writebyte(damageSource, global.eventBuffer);
