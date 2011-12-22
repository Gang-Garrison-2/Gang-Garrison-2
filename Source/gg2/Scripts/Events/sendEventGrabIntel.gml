/**
 * argument0: The player who grabbed the intel.
 */
 
write_ubyte(global.eventBuffer, GRAB_INTEL);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, argument0));
        write_ushort(global.serializeBuffer, x*5);
        write_ushort(global.serializeBuffer, y*5);
        write_byte(global.serializeBuffer, hspeed*17);
        write_byte(global.serializeBuffer, vspeed*17);
