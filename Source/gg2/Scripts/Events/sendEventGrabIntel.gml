/**
 * argument0: The player who grabbed the intel
 */
 
writebyte(GRAB_INTEL, global.eventBuffer);
writebyte(ds_list_find_index(global.players, argument0), global.eventBuffer);