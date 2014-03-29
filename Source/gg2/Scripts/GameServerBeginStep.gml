{
var size, i, client, player, joiningPlayer, socket, playerName, numSpawnpoints, spawnpointID, sockstatus, receiveBuffer, hitBufferEnd, processedUntil, temp, limit;

// Register with Lobby Server every 30 seconds
if(global.useLobbyServer and (frame mod 900)==0) {
    if(lobbysocket!=-1) {
        // Resolve the Lobby Server's IP every 10 minutes, in case the IP changed
        if((frame mod 18000)==0) {
            lobbyip = hostip(LOBBY_SERVER_HOST);
        }
        
        global.map_serverName = "[" + string(global.currentMap) +"] " + string(global.serverName) + " [" + string(ds_list_size(global.players)) + "/" + string(global.playerLimit) + "]";
        
        clearbuffer(0);
        writebyte(4, 0);
        writebyte(8, 0);
        writebyte(15, 0);
        writebyte(16, 0);
        writebyte(23, 0);
        writebyte(42, 0);
        writebyte(PROTOCOL_VERSION, 0);
        writeshort(global.hostingPort, 0);
        writebyte(string_length(global.map_serverName), 0);
        writechars(global.map_serverName, 0);
        sendmessage(lobbysocket, lobbyip, LOBBY_SERVER_PORT, 0);   
    }
}

frame += 1;
limit = 0;
if(impendingMapChange > 0) impendingMapChange -= 1; // countdown until a map change

if(global.myself.object != -1) {
    clearbuffer(global.sendBuffer);
    ClientInputstate(playerControl.keybyte, global.myself.object.x, global.myself.object.y);
    sendmessage(global.serverSocket,0,0,global.sendBuffer);
    playerControl.keybyte = 0;
}

    client = tcpaccept(global.tcpListener, 1);
    if(client != 0) {
        setformat(client, 2, 0);
        setnagle(client, true);
        
        joiningPlayer = instance_create(0,0,JoiningPlayer);
        joiningPlayer.socket = client;

        clearbuffer(global.sendBuffer);

        receiveBuffer = joiningPlayer.buffer;
        socket = joiningPlayer.socket;
    
        setsync(socket, 1);
        sockstatus = nibbleMessage(socket,2,receiveBuffer);
        setpos(0, receiveBuffer);
    
        if(sockstatus == 2) {
        // Connection closed unexpectedly, remove client
            with(joiningPlayer) {
                instance_destroy();
            }

        } else if(sockstatus == 0) {

            if(ds_list_size(global.players) == global.playerLimit) {
                limit = 1;
            }
        
            if((readbyte(receiveBuffer) == PLAYER_JOIN) and (limit != 1))
            {
                                        
                    size = readbyte(receiveBuffer);
                    sockstatus = nibbleMessage(socket,size+2,receiveBuffer);
                    if(sockstatus == 0) {                        
                        clearbuffer(0);
                        ServerJoinUpdate(0);
                    
                        player = instance_create(0,0,Player);
                        player.name = readchars(size, receiveBuffer);
                        player.name = string_copy(player.name, 0, min(string_length(player.name), MAX_PLAYERNAME_LENGTH));

                        player.socket = socket;
                        ds_list_add(global.players, player);
                        
                        sendMessageNonblock(socket, 0);
                        copybuffer(player.sendBuffer, 0);
                        
                        with(joiningPlayer) {
                            instance_destroy();
                        }
                
                        ServerPlayerJoin(player.name, global.sendBuffer);
                    }
            }
            else {
                clearbuffer(0);
                if(limit) {
                    ServerServerFull(0);
                    sendMessageNonblock(socket,0);
                }
                closesocket(socket);
                with(joiningPlayer) {
                    instance_destroy();
                }
        }
    }
}

// Service all players
for(i=0; i<ds_list_size(global.players); i+=1) {
    player = ds_list_find_value(global.players, i);
    
    if(player.recentlyKilledBy != -1) {
        if(player.recentlyKilledBy != 0) {
            recordKillInLog(player, player.recentlyKilledBy, player.recentlyKilledWith);
        } else {
            recordKillInLog(player, -1, player.recentlyKilledWith);
        }
        ServerPlayerDeath(player, global.sendBuffer);
        player.recentlyKilledBy = -1;
    }
        
    // Fill up the buffer from the player socket
    // 100 Bytes should be plenty.
    receiveBuffer = player.receiveBuffer;
    socket = player.socket;
    setsync(socket, 1);
    sockstatus = nibbleMessage(socket,100,receiveBuffer);
    
    if(sockstatus == 2) {
        removePlayer(player);
        ServerPlayerLeave(i);
        i-=1;
    } else {
        if(player.object==-1) {
            if(player.team != TEAM_SPECTATOR and player.canRespawn == true) {
                if(player.team == TEAM_RED) {
                   numSpawnpoints = ds_list_size(global.spawnPointsRedX);
                } else {
                    numSpawnpoints = ds_list_size(global.spawnPointsBlueX);
                }
                spawnpointID = floor(random(numSpawnpoints));
                ServerPlayerSpawn(i, spawnpointID , global.sendBuffer);
                spawnPlayer(player, spawnpointID);
            }
        }
     
        hitBufferEnd = false;
        processedUntil = 0;
        
        while((not hitBufferEnd) and (bytesleft(receiveBuffer)>=1)) {
            switch(readbyte(receiveBuffer)) {
                case PLAYER_LEAVE:
                    removePlayer(player);
                    ServerPlayerLeave(i);
                    i-=1;
                    hitBufferEnd = true;
                    break;
                    
                case PLAYER_CHANGECLASS:
                    if(bytesleft(receiveBuffer)>=1) {
                        temp = readbyte(receiveBuffer);
                        if(getCharacterObject(player.team, temp) != -1) {
                            player.class = temp
                            if(player.object != -1) {
                                with(player.object) {
                                instance_destroy();
                                }
                                player.object = -1;
                                player.canRespawn=false;
                                player.alarm[5] = 150;
                            }
                            ServerPlayerChangeclass(i, player.class, global.sendBuffer);
                        }
                        processedUntil = getpos(1, receiveBuffer);
                    } else {
                        hitBufferEnd = true;
                    }
                    break;
                    
                case PLAYER_CHANGETEAM:
                    if(bytesleft(receiveBuffer)>=1) {
                        temp = readbyte(receiveBuffer);
                        if(getCharacterObject(temp, player.class) != -1 || temp == TEAM_SPECTATOR) {
                            player.team = temp;
                            if(player.object != -1) {
                                with(player.object) {
                                instance_destroy();
                                }
                                player.object = -1;
                                player.canRespawn = false;
                                player.alarm[5] = 150;
                            }
                            ServerPlayerChangeteam(i, player.team, global.sendBuffer);
                        }
                        processedUntil = getpos(1, receiveBuffer);
                    } else {
                        hitBufferEnd = true;
                    }
                    break;                   
                    
                    
                case CHAT_BUBBLE:
                    var bubbleImage;
                    if(bytesleft(receiveBuffer)>=1) {
                        bubbleImage = readbyte(receiveBuffer);
                        writebyte(CHAT_BUBBLE,global.sendBuffer);
                        writebyte(i, global.sendBuffer);
                        writebyte(bubbleImage,global.sendBuffer);
                        
                        setChatBubble(player, bubbleImage);
                        
                        processedUntil = getpos(1, receiveBuffer);
                    } else {
                        hitBufferEnd = true;
                    }
                    break;                    
                    
                    
                case BUILD_SENTRY:
                    if(bytesleft(receiveBuffer)>=1) {
                        writebyte(BUILD_SENTRY,global.sendBuffer);
                        writebyte(i, global.sendBuffer);
                        
                        buildSentry(player);
                        
                        processedUntil = getpos(1, receiveBuffer);
                    } else {
                        hitBufferEnd = true;
                    }
                    break;                                       

                case DESTROY_SENTRY:
                    if(bytesleft(receiveBuffer)>=1) {

                        with player.object {sentryBuilt=0;}
                        
                        processedUntil = getpos(1, receiveBuffer);
                    } else {
                        hitBufferEnd = true;
                    }
                    break;                     
                                                            
                case INPUTSTATE:
                    if(bytesleft(receiveBuffer)>=3) {
                        if(player.object != -1) {
                            player.object.keyState = readbyte(receiveBuffer);
                            player.object.netAimDirection = readshort(receiveBuffer);
                            player.object.aimDirection = player.object.netAimDirection*360/65536;
                        } else {
                            readbyte(receiveBuffer);
                            readshort(receiveBuffer);
                        }
                        processedUntil = getpos(1, receiveBuffer);
                    } else {
                        hitBufferEnd = true;
                    }
                    break;
            }
        }

        // remove the processed bytes from the buffer        
        if(hitBufferEnd) {
            if(not variable_global_exists("tempBuffer")) {
                global.tempBuffer = createbuffer();
            }
            clearbuffer(global.tempBuffer);
            copybuffer2(global.tempBuffer, processedUntil, buffsize(receiveBuffer)-processedUntil, receiveBuffer);
            clearbuffer(receiveBuffer);
            copybuffer(receiveBuffer, global.tempBuffer);
        } else {
            clearbuffer(receiveBuffer);
        }
    }
}


if((frame mod 5) == 0) {
    serializeState(QUICK_UPDATE, global.sendBuffer);
} else {
    serializeState(INPUTSTATE, global.sendBuffer);
}



if (global.redCaps ==global.caplimit || global.blueCaps ==global.caplimit) and global.mapchanging == 0
{
    global.mapchanging=1;
    global.currentMapIndex += 1;
    if( global.currentMapIndex == ds_list_size(global.map_rotation) ) {
        global.currentMapIndex = 0;
    }

    global.nextMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
    
    /*switch(global.currentMap)
    {
        case "2dfort": 
        global.nextMap = "TwodFort"; 
        break;
        
        case "2dfort_2": 
        global.nextMap = "TwodFortTwo"; 
        break;
        
        case "helltrikky_1": 
        global.nextMap = "HELLTRIKKY1";
        break;
        
        case "classicwell": 
        global.nextMap = "ClassicWell";
        break;
        
        case "Orange": 
        global.nextMap = "Orange"; 
        break;
        
        case "Avanti": 
        global.nextMap = "Avanti"; 
        break;
        
        case "Castle": 
        global.nextMap = "Castle"; 
        break;
        
        case "Containment": 
        global.nextMap = "Containment";
        break;
        
        case "Heenok": 
        global.nextMap = "Heenok"; 
        break;
        
        default:
        show_message("Error: invalid map in map rotation data structure");
    }
    */ 
    /*switch(global.currentMap)
    {
        case "2dfort": global.nextMap = "TwodFortTwo"; global.currentMap = "2dfort_2";
        break;
        case "2dfort_2": global.nextMap = "HELLTRIKKY1"; global.currentMap = "helltrikky_1";
        break;
        case "helltrikky_1": global.nextMap = "ClassicWell"; global.currentMap = "classicwell";
        break;
        case "classicwell": global.nextMap = "Orange"; global.currentMap = "Orange";
        break;
        case "Orange": global.nextMap = "Avanti"; global.currentMap = "Avanti";
        break;
        case "Avanti": global.nextMap = "Castle"; global.currentMap = "Castle";
        break;
        case "Castle": global.nextMap = "Containment"; global.currentMap = "Containment";
        break;
        case "Containment": global.nextMap = "Heenok"; global.currentMap = "Heenok";
        break;
        case "Heenok": global.nextMap = "TwodFort"; global.currentMap = "2dfort";
        break;
    }*/

    impendingMapChange = 300; // in 300 frames, we'll do a map change
    
    writebyte(MAP_END,global.sendBuffer);
    writebyte(string_length(global.nextMap), global.sendBuffer);
    writechars(global.nextMap, global.sendBuffer);
    //writestring(global.nextMap,global.sendBuffer);
    mapEnd();
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
        gotoInternalMapRoom(global.currentMap);
    }
    ServerChangeMap(global.currentMap, global.currentMapURL, global.currentMapMD5, global.sendBuffer);
    impendingMapChange = -1;
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        player.kills=0;
        player.caps=0;
        player.healpoints=0;
    }
}


for(i=1; i<ds_list_size(global.players); i+=1) {
    player = ds_list_find_value(global.players, i);
    socket = player.socket;
    copybuffer(player.sendBuffer, global.sendBuffer);
    sendMessageNonblock(socket, player.sendBuffer);
}

with(Character) {
    event_user(1);
}

}