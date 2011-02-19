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
    lobbyBuffer = buffer_create();
    
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
    
    if(socket_has_error(player.socket)) {
        removePlayer(player);
        ServerPlayerLeave(i);
        i-=1;
    } else {
        if(player.authorized == false) {
            player.passwordCount += 1;
            if(player.passwordCount == 30*30) {
                write_ubyte(player.socket, KICK);
                write_ubyte(player.socket, KICK_PASSWORDCOUNT);
                socket_destroy(player.socket);
                player.socket = -1;
            }
        }
        processClientCommands(player, i);        
    }
}

if syncTimer == 1 || ((frame mod 3600)==0) || global.setupTimer == 180 {
    serializeState(CAPS_UPDATE, global.sendBuffer);
    syncTimer = 0;
}

global.buffer_team = TEAM_SPECTATOR;
if((frame mod 7) == 0) {
    //Copy normal data into new buffer
    //serializeState(QUICK_UPDATE, global.sendBuffer);
    //Toggle to red team
    global.buffer_team = TEAM_RED;
    buffer_clear(global.buffer_red);
    serializeState(QUICK_UPDATE, global.buffer_red);
    //Toggle to blue team
    global.buffer_team = TEAM_BLUE;
    buffer_clear(global.buffer_blue);
    serializeState(QUICK_UPDATE, global.buffer_blue);
    global.buffer_team = TEAM_SPECTATOR;
    //Toggle back to all
    buffer_clear(global.buffer_all);
    serializeState(QUICK_UPDATE, global.buffer_all);
    global.buffer_switch = true;
} else {
serializeState(INPUTSTATE, global.sendBuffer);
}



if (global.winners != -1 and !global.mapchanging)
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
    global.mapchanging = 1;
    impendingMapChange = 300; // in 300 frames (ten seconds), we'll do a map change
    
    write_ubyte(global.sendBuffer, MAP_END);
    write_ubyte(global.sendBuffer, string_length(global.nextMap));
    write_string(global.sendBuffer, global.nextMap);
    write_ubyte(global.sendBuffer, global.winners);
    write_ubyte(global.sendBuffer, global.currentMapArea);
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
            player.stats[KILLS] = 0;
            player.stats[DEATHS] = 0;
            player.stats[CAPS] = 0;
            player.stats[ASSISTS] = 0;
            player.stats[DESTRUCTION] = 0;
            player.stats[STABS] = 0;
            player.stats[HEALING] = 0;
            player.stats[DEFENSES] = 0;
            player.stats[INVULNS] = 0;
            player.stats[BONUS] = 0;
            player.stats[DOMINATIONS] = 0;
            player.stats[REVENGE] = 0;
            player.stats[POINTS] = 0;
            player.roundStats[KILLS] = 0;
            player.roundStats[DEATHS] = 0;
            player.roundStats[CAPS] = 0;
            player.roundStats[ASSISTS] = 0;
            player.roundStats[DESTRUCTION] = 0;
            player.roundStats[STABS] = 0;
            player.roundStats[HEALING] = 0;
            player.roundStats[DEFENSES] = 0;
            player.roundStats[INVULNS] = 0;
            player.roundStats[BONUS] = 0;
            player.roundStats[DOMINATIONS] = 0;
            player.roundStats[REVENGE] = 0;
            player.roundStats[POINTS] = 0;
            player.team = TEAM_SPECTATOR;
        }
        player.timesChangedCapLimit = 0;
        player.alarm[5]=1;
    }
}

for(i=1; i<ds_list_size(global.players); i+=1) {
    player = ds_list_find_value(global.players, i);
    write_buffer(player.socket, global.eventBuffer);
    write_buffer(player.socket, global.sendBuffer);
    if (global.buffer_switch)
    {
    if (player.team == TEAM_RED) write_buffer(player.socket, global.buffer_red);
    else if (player.team == TEAM_BLUE) write_buffer(player.socket, global.buffer_blue);
    else write_buffer(player.socket, global.buffer_all);
    }
    socket_send(player.socket);
}
if (global.buffer_switch) global.buffer_switch = false;
buffer_clear(global.eventBuffer);

with(Character) {
    event_user(1);
}

