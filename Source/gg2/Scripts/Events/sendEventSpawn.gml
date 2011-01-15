/**
 * Notify all clients that a player is respawning.
 *
 * argument0: The player who spawned
 * argument1: The spawnpoint ID
 * argument2: The spawn group
 */

write_ubyte(global.eventBuffer, PLAYER_SPAWN);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players,argument0));
write_ubyte(global.eventBuffer, argument1);
write_ubyte(global.eventBuffer, argument2);
