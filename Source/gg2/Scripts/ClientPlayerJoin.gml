{
    var playername;
    writebyte(PLAYER_JOIN, global.sendBuffer);
    playername = string_copy(argument0, 0, min(string_length(argument0), MAX_PLAYERNAME_LENGTH));
    writebyte(string_length(playername), global.sendBuffer);
    writechars(playername, global.sendBuffer);
}