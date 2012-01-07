/**
 * argument0: The player whose weapon was fired. Must have a character.
 * argument1: Random seed (0-65535)
 */
 
write_ubyte(global.eventBuffer, WEAPON_FIRE);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, argument0));

write_ushort(global.eventBuffer, argument0.object.x*5);
write_ushort(global.eventBuffer, argument0.object.y*5);
write_byte(global.eventBuffer, argument0.object.hspeed*17);
write_byte(global.eventBuffer, argument0.object.vspeed*17);

write_ushort(global.eventBuffer, argument1);
