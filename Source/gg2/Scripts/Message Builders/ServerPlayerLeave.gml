// Write a message to the buffer-ish argument1 that informs the clients
// that the player with id argument0 left the game.

write_ubyte(argument1, PLAYER_LEAVE);
write_ubyte(argument1, argument0);
