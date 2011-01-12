var playername;
write_ubyte(global.sendBuffer, PLAYER_JOIN);
playername = string_copy(argument0, 0, min(string_length(argument0), MAX_PLAYERNAME_LENGTH));
write_ubyte(global.sendBuffer, string_length(playername));
write_string(global.sendBuffer, playername);
