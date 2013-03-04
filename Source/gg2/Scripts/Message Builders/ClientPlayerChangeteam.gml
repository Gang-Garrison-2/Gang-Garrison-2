// Write a message to the buffer-ish argument1 that informs the server
// that we want to switch to team argument0.

write_ubyte(argument1, PLAYER_CHANGETEAM);
write_ubyte(argument1, argument0);
