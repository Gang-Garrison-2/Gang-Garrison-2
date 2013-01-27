/**
 * Notify all clients that a player has authenticated for some rewards
 *
 * argument0: The player who just did so
 * argument1: The reward value
 */

write_ubyte(global.eventBuffer, REWARD_UPDATE);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players,argument0));
write_ushort(global.eventBuffer, argument1);
