receiveCompleteMessage(global.serverSocket,5,0);
winners = readbyte(0);
redMVPs = readbyte(0);
blueMVPs = readbyte(0);
consecutiveRedWins = readbyte(0);
consecutiveBlueWins = readbyte(0);

for(i=0; i < redMVPs; i+=1) {
    receiveCompleteMessage(global.serverSocket,6,0);
    redMVPIndex[i] = readbyte(0);
    redMVP[i] = ds_list_find_value(global.players,redMVPIndex[i]);
    redMVP[i].roundKills = readbyte(0);
    redMVP[i].roundStabKills = readbyte(0);
    redMVP[i].roundHealed = readshort(0);
    redMVP[i].roundHealPoints = readbyte(0);
}

for(i=0; i < blueMVPs; i+=1) {
    receiveCompleteMessage(global.serverSocket,6,0);
    blueMVPIndex[i] = readbyte(0);
    blueMVP[i] = ds_list_find_value(global.players,blueMVPIndex[i]);
    blueMVP[i].roundKills = readbyte(0);
    blueMVP[i].roundStabKills = readbyte(0);
    blueMVP[i].roundHealed = readshort(0);
    blueMVP[i].roundHealPoints = readbyte(0);
}

doEventArenaEndRound();
