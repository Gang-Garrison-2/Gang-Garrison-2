/**
 * Notify all clients that a player just started an Ubercharge
 *
 * argument0: The player who just fired his Ubercharge
 */
 
write_ubyte(global.eventBuffer, UBER);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players,argument0));
