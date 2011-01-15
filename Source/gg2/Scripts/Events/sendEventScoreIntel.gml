/**
 * argument0: The player who scored with the intel
 */
 
write_ubyte(global.eventBuffer, SCORE_INTEL);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, argument0));
