/**
 * Notify all clients that a player is respawning.
 *
 * argument0: The player who spawned
 * argument1: The spawnpoint ID
 */

writebyte(PLAYER_SPAWN, global.eventBuffer);
writebyte(ds_list_find_index(global.players,argument0), global.eventBuffer);
writebyte(argument1, global.eventBuffer);