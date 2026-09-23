/**
 * argument0: The player whose weapon was fired. Must have a character.
 * argument1: Random seed (0-65535)
 */
 
write_ubyte(global.sendBuffer, WEAPON_FIRE);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players, argument0));

write_ushort(global.sendBuffer, argument0.object.x*5);
write_ushort(global.sendBuffer, argument0.object.y*5);
write_byte(global.sendBuffer, argument0.object.hspeed*8.5);
write_byte(global.sendBuffer, argument0.object.vspeed*8.5);

write_ushort(global.sendBuffer, argument1);
