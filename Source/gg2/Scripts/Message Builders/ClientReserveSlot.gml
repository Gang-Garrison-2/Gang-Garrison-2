var playername;
write_ubyte(argument0, RESERVE_SLOT);
playername = string_copy(global.playerName, 0, min(string_length(global.playerName), MAX_PLAYERNAME_LENGTH));
write_ubyte(argument0, string_length(playername));
write_string(argument0, playername);
