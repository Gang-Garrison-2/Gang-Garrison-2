/**
 * argument0: The player who grabbed the intel
 */
 
write_ubyte(global.sendBuffer, GRAB_INTEL);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players, argument0));
