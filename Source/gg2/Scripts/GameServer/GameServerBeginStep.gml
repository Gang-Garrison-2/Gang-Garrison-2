var size, i, client, player, joiningPlayer, socket, playerName, numSpawnpoints, spawnpointID, sockstatus, receiveBuffer, hitBufferEnd, processedUntil, temp, limit;
if serverbalance!=0 balancecounter+=1;

// Register with Lobby Server every 30 seconds
if(global.useLobbyServer and (frame mod 900)==0) {
    if global.dedicatedMode == 1 noOfPlayers = ds_list_size(global.players) - 1;
    else noOfPlayers = ds_list_size(global.players);
    if global.serverPassword != "" {
        global.map_serverName = "!private!" + "[" + string(global.currentMap) +"] " + global.serverName + " [" + string(noOfPlayers) + "/" + string(maxplayers) + "]";
    }
    else global.map_serverName = "[" + string(global.currentMap) +"] " + string(global.serverName) + " [" + string(noOfPlayers) + "/" + string(maxplayers) + "]";

    var lobbyBuffer;
    
    // Magic numbers
    write_ubyte(lobbyBuffer, 4);
    write_ubyte(lobbyBuffer, 8);
    write_ubyte(lobbyBuffer, 15);
    write_ubyte(lobbyBuffer, 16);
    write_ubyte(lobbyBuffer, 23);
    write_ubyte(lobbyBuffer, 42);
    
    // Indicate that a UUID follows
    write_ubyte(lobbyBuffer, 128);
    
    // Send version UUID (big endian)
    for(i=0; i<16; i+=1) {
        write_ubyte(lobbyBuffer, global.protocolUuid[i]);
    }
    write_ushort(lobbyBuffer, global.hostingPort);
    write_ubyte(lobbyBuffer, string_length(global.map_serverName));
    write_string(lobbyBuffer, global.map_serverName);
    udp_send(lobbyBuffer, LOBBY_SERVER_HOST, LOBBY_SERVER_PORT);
    buffer_destroy(lobbyBuffer);
}

frame += 1;
limit = 0;
if(impendingMapChange > 0) impendingMapChange -= 1; // countdown until a map change

if(global.myself.object != -1) {
    buffer_clear(global.sendBuffer);
    ClientInputstate(playerControl.keybyte, global.myself.object.x, global.myself.object.y);
    write_buffer(global.serverSocket, global.sendBuffer);
    socket_send(global.serverSocket);
    playerControl.keybyte = 0;
}

buffer_clear(global.sendBuffer);

acceptJoiningPlayer();
with(JoiningPlayer) {
    serviceJoiningPlayer();
}

// Service all players
for(i=0; i<ds_list_size(global.players); i+=1) {
    player = ds_list_find_value(global.players, i);
    // Fill up the buffer from the player socket
    // 100 Bytes should be plenty.
    socket = player.socket;
    
    if(socket_has_error(socket)) {
        removePlayer(player);
        ServerPlayerLeave(i);
        i-=1;
    } else {
        if(player.authorized == false) {
            player.passwordCount += 1;
            if(player.passwordCount == 30*30) {
                write_ubyte(player.socket, KICK);
                write_ubyte(player.socket, KICK_PASSWORDCOUNT);
                socket_destroy(player.socket, false);
            }
        }
    } else {
        processClientCommands(player, i);
    }
}

if syncTimer == 1 || ((frame mod 3600)==0) || global.setupTimer == 180 {
    serializeState(CAPS_UPDATE, global.sendBuffer);
    syncTimer = 0;
}

if((frame mod 7) == 0) {
    serializeState(QUICK_UPDATE, global.sendBuffer);
} else {
    serializeState(INPUTSTATE, global.sendBuffer);
}



if (global.winners != -1 and (global.mapchanging == 0) /*or (global.vipDied == true) or (global.goalReached == true)*/ )
{
            
    if global.winners == TEAM_RED && global.currentMapArea < global.totalMapAreas {
    global.nextMap = global.currentMap;
    global.currentMapArea += 1;
    }

    else { 
        global.currentMapIndex += 1;
        global.currentMapArea = 1;
        if (global.currentMapIndex == ds_list_size(global.map_rotation)) 
        {
            global.currentMapIndex = 0;
        }
        global.nextMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
    }
    global.mapchanging=1;
    impendingMapChange = 300; // in 300 frames (ten seconds), we'll do a map change
    
    writebyte(MAP_END,global.sendBuffer);
    writebyte(string_length(global.nextMap), global.sendBuffer);
    writechars(global.nextMap, global.sendBuffer);
    writebyte(global.winners,global.sendBuffer);
    writebyte(global.currentMapArea, global.sendBuffer);
    if !instance_exists(ScoreTableController) instance_create(0,0,ScoreTableController);
    instance_create(0,0,WinBanner);
}

// if map change timer hits 0, do a map change
if(impendingMapChange == 0) {
    global.mapchanging = 0;
    global.currentMap = global.nextMap;
    if(file_exists("Maps/" + global.currentMap + ".png")) { // if this is an external map
        // get the md5 and url for the map
        global.currentMapURL = CustomMapGetMapURL(global.currentMap);
        global.currentMapMD5 = CustomMapGetMapMD5(global.currentMap);
        room_goto_fix(CustomMapRoom);
    } else { // internal map, so at the very least, MD5 must be blank
        global.currentMapURL = "";
        global.currentMapMD5 = "";
        if(gotoInternalMapRoom(global.currentMap) != 0) {
            show_message("Error:#Map " + global.currentMap + " is not in maps folder, and it is not a valid internal map.#Exiting.");
            game_end();
        }
    }
    ServerChangeMap(global.currentMap, global.currentMapURL, global.currentMapMD5, global.sendBuffer);
    impendingMapChange = -1;
    
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        if(global.currentMapArea == 1){
            player.kills=0;
            player.caps=0;
            player.healpoints=0;
            player.team = TEAM_SPECTATOR;
        }
        player.timesChangedCapLimit = 0;
        player.alarm[5]=1;
    }
}

for(i=1; i<ds_list_size(global.players); i+=1) {
    player = ds_list_find_value(global.players, i);
    socket = player.socket;
    copybuffer(player.sendBuffer, global.eventBuffer);
    copybuffer(player.sendBuffer, global.sendBuffer);
    sendMessageNonblock(socket, player.sendBuffer);
}
clearbuffer(global.eventBuffer);

with(Character) {
    event_user(1);
}

//if (frame mod 2) == 0 screen_redraw();
