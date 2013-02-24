/**
 * Notify all clients that a player is respawning.
 *
 * argument0: The player who spawned
 * argument1: The spawnpoint ID
 * argument2: The spawn group
 */

write_ubyte(global.sendBuffer, PLAYER_SPAWN);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument0));
write_ubyte(global.sendBuffer, argument1);
write_ubyte(global.sendBuffer, argument2);
