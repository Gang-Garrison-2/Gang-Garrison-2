/**
 * Notify all clients that a player has authenticated for some rewards
 *
 * argument0: The player who just did so
 * argument1: The reward string
 */

write_ubyte(global.sendBuffer, REWARD_UPDATE);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument0));
write_ushort(global.sendBuffer, string_length(argument1));
write_string(global.sendBuffer, argument1);
