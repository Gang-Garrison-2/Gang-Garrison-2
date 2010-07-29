/**
 * Notify all clients that a player just started an Ubercharge
 *
 * argument0: The player who just fired his Ubercharge
 */
 
writebyte(UBER,global.eventBuffer);
writebyte(ds_list_find_index(global.players,argument0), global.eventBuffer);