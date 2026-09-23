/**
 * argument0: The player whose weapon was fired. Must have a character.
 * argument1: Random seed (0-65535)
 */
 
write_ubyte(global.sendBuffer, WEAPON_FIRE);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players, argument0));

// TODO(enigma): temp var avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
var playerObject;
playerObject = argument0.object;
write_ushort(global.sendBuffer, playerObject.x*5);
write_ushort(global.sendBuffer, playerObject.y*5);
write_byte(global.sendBuffer, playerObject.hspeed*8.5);
write_byte(global.sendBuffer, playerObject.vspeed*8.5);

write_ushort(global.sendBuffer, argument1);
