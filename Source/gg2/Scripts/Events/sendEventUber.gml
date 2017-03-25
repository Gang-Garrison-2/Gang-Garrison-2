/**
 * Notify all clients that a player just started an Ubercharge
 *
 * argument0: The player who just fired his Ubercharge
 */
 
write_ubyte(global.sendBuffer, UBER);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument0));
