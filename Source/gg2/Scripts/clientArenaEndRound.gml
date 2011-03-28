receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
winners = read_ubyte(global.tempBuffer);
redMVPs = read_ubyte(global.tempBuffer);
blueMVPs = read_ubyte(global.tempBuffer);
redWins = read_ubyte(global.tempBuffer);
blueWins = read_ubyte(global.tempBuffer);

for(i=0; i < redMVPs; i+=1) {
    receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
    redMVPIndex[i] = read_ubyte(global.tempBuffer);
    redMVP[i] = ds_list_find_value(global.players,redMVPIndex[i]);
    redMVP[i].roundStats[KILLS] = read_ubyte(global.tempBuffer);
    redMVP[i].roundStats[HEALING] = read_ushort(global.tempBuffer);
    redMVP[i].roundStats[POINTS] = read_ubyte(global.tempBuffer);
}

for(i=0; i < blueMVPs; i+=1) {
    receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
    blueMVPIndex[i] = read_ubyte(global.tempBuffer);
    blueMVP[i] = ds_list_find_value(global.players,blueMVPIndex[i]);
    blueMVP[i].roundStats[KILLS] = read_ubyte(global.tempBuffer);
    blueMVP[i].roundStats[HEALING] = read_ushort(global.tempBuffer);
    blueMVP[i].roundStats[POINTS] = read_byte(global.tempBuffer);
}

doEventArenaEndRound();
