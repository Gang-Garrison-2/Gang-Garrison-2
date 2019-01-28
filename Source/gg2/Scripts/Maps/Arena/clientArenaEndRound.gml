var win;
receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
win = read_ubyte(global.tempBuffer);
mvps[TEAM_RED] = read_ubyte(global.tempBuffer);
mvps[TEAM_BLUE] = read_ubyte(global.tempBuffer);
redWins = read_ubyte(global.tempBuffer);
blueWins = read_ubyte(global.tempBuffer);

for(i=0; i < mvps[TEAM_RED]; i+=1) {
    receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
    redMVP[i] = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
    redMVP[i].roundStats[KILLS] = read_ubyte(global.tempBuffer);
    redMVP[i].roundStats[HEALING] = read_ushort(global.tempBuffer);
    redMVP[i].roundStats[POINTS] = read_ubyte(global.tempBuffer);
}

for(i=0; i < mvps[TEAM_BLUE]; i+=1) {
    receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
    blueMVP[i] = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
    blueMVP[i].roundStats[KILLS] = read_ubyte(global.tempBuffer);
    blueMVP[i].roundStats[HEALING] = read_ushort(global.tempBuffer);
    blueMVP[i].roundStats[POINTS] = read_ubyte(global.tempBuffer);
}

doEventArenaEndRound(win);
