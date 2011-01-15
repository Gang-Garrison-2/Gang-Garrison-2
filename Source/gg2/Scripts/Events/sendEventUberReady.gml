/**
 * Notify all clients that a player just filled his uberMeter
 *
 * argument0: The player who just filled his uberMeter
 */

write_ubyte(global.eventBuffer, UBER_CHARGED);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players,argument0));
