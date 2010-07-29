/**
 * argument0: The player who scored with the intel
 */
 
writebyte(SCORE_INTEL, global.eventBuffer);
writebyte(ds_list_find_index(global.players, argument0), global.eventBuffer);