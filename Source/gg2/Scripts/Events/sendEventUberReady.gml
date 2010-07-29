/**
 * Notify all clients that a player just filled his uberMeter
 *
 * argument0: The player who just filled his uberMeter
 */

writebyte(UBER_CHARGED,global.eventBuffer);
writebyte(ds_list_find_index(global.players,argument0),global.eventBuffer);