var size, i, client, player, joiningPlayer, socket, playerName, numSpawnpoints, spawnpointID, sockstatus, receiveBuffer, hitBufferEnd, processedUntil, temp, limit;
if serverbalance!=0 balancecounter+=1;

// Register with Lobby Server every 30 seconds
if(global.useLobbyServer and (frame mod 900)==0) {
    if(lobbysocket!=-1) {
        // Resolve the Lobby Server's IP every 10 minutes, in case the IP changed
        if((frame mod 18000)==0) {
            lobbyip = hostip(LOBBY_SERVER_HOST);
        }
        
        if global.dedicatedMode == 1 noOfPlayers = ds_list_size(global.players) - 1;
        else noOfPlayers = ds_list_size(global.players);
        if global.serverPassword != "" {
            global.map_serverName = "!private!" + "[" + string(global.currentMap) +"] " + global.serverName + " [" + string(noOfPlayers) + "/" + string(maxplayers) + "]";
        }
        else global.map_serverName = "[" + string(global.currentMap) +"] " + string(global.serverName) + " [" + string(noOfPlayers) + "/" + string(maxplayers) + "]";


        clearbuffer(0);
        // Magic numbers
        writebyte(4, 0);
        writebyte(8, 0);
        writebyte(15, 0);
        writebyte(16, 0);
        writebyte(23, 0);
        writebyte(42, 0);
        
        // Indicate that a UUID follows
        writebyte(128, 0);
        
        // Send version UUID (big endian)
        for(i=0; i<16; i+=1) {
            writebyte(global.protocolUuid[i], 0);
        }
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
                        if string_count("#",player.name) > 0 {
                            player.name = "I <3 Bacon";
                        }
                        
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
                                if (player.quickspawn=0){
                                    player.alarm[5] = global.Server_Respawntime;
                                } else {
                                    player.alarm[5] = 1;
                                }    
                            } else if(player.alarm[5]<=0) {
                                player.alarm[5] = 1;
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
                        if(getCharacterObject(temp, player.class) != -1 or temp==TEAM_SPECTATOR) {  
                            if(player.object != -1) {
                                with(player.object) {
                                    instance_destroy();
                                }
                                player.object = -1;
                                player.alarm[5] = global.Server_Respawntime;
                            } else if(player.alarm[5]<=0) {
                                player.alarm[5] = 1;
                            }
                            player.team = temp;
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
                        if global.aFirst {
                            bubbleImage = 0;
                        }
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
                    if(player.object != -1) {
                        if(player.class == CLASS_ENGINEER
                                && collision_circle(player.object.x,player.object.y,50,Sentry,false,true)<0
                                && player.object.nutsNBolts == 100 && player.quickspawn != 1
                                && player.sentry == -1){ 
                            buildSentry(player);
                            writebyte(BUILD_SENTRY,global.sendBuffer);
                            writebyte(i, global.sendBuffer);
                            processedUntil = getpos(1, receiveBuffer);
                        }
                    }
                    break;                                       

                case DESTROY_SENTRY:
                    if(player.sentry != -1) {
                        with(player.sentry) {
                            instance_destroy();
                        }
                    }
                    player.sentry = -1;                        
                    processedUntil = getpos(1, receiveBuffer);
                    break;                     
                
                case DROP_INTEL:                                                                  
                    if(player.object != -1) {
                        writebyte(DROP_INTEL,global.sendBuffer);
                        writebyte(i, global.sendBuffer);
                        with player.object event_user(5);  
                    }    
                    processedUntil = getpos(1, receiveBuffer);
                    break;     
                      
                case OMNOMNOMNOM:
                    if player.object != -1 {
                        if player.humiliated == 0 
                        && player.object.taunting==false && player.object.omnomnomnom==false
                        && player.class==CLASS_HEAVY {                            
                            writebyte(OMNOMNOMNOM,global.sendBuffer);
                            writebyte(i, global.sendBuffer);
                            with player.object {
                                omnomnomnom=true;
                                if player.team == TEAM_RED {
                                    omnomnomnomindex=0;
                                    omnomnomnomend=31;
                                } else if player.team==TEAM_BLUE {
                                    omnomnomnomindex=32;
                                    omnomnomnomend=63;
                                } 
                                xscale=image_xscale;
                            }             
                        }
                    }      
                    processedUntil = getpos(1, receiveBuffer);
                    break;
                     
                case SCOPE_IN:
                     if player.object != -1 {
                        if player.class == CLASS_SNIPER {
                           writebyte(SCOPE_IN,global.sendBuffer);
                           writebyte(i, global.sendBuffer);
                           with player.object {
                                zoomed = true;
                                runPower = 0.6;
                                jumpStrength = 6;
                           }
                        }
                     }
                     processedUntil = getpos(1, receiveBuffer);
                     break;
                        
                case SCOPE_OUT:
                     if player.object != -1 {
                        if player.class == CLASS_SNIPER {
                           writebyte(SCOPE_OUT,global.sendBuffer);
                           writebyte(i, global.sendBuffer);
                           with player.object {
                                zoomed = false;
                                runPower = 0.9;
                                jumpStrength = 8;
                           }
                        }
                     }
                     processedUntil = getpos(1, receiveBuffer);
                     break;
                                                              
                case PASSWORD_SEND:
                    if(bytesleft(receiveBuffer)>=1) {
                        passwordlength = readbyte(receiveBuffer);
                        if(bytesleft(receiveBuffer)>=passwordlength) {
                            password = readchars(passwordlength, receiveBuffer);
                            if global.serverPassword != password {
                                socket = player.socket;
                                clearbuffer(player.sendBuffer);
                                writebyte(PASSWORD_WRONG, player.sendBuffer);
                                sendMessageNonblock(socket, player.sendBuffer);
                                closesocket(socket);
                            } else player.authorized = true;
                            processedUntil = getpos(1, receiveBuffer);
                        } else {
                            hitBufferEnd = true;
                        }  
                    } else {
                        hitBufferEnd = true;
                    }
                    break;
                    
                case PLAYER_CHANGENAME:
                    if(bytesleft(receiveBuffer)>=1) {
                        nameLength = readbyte(receiveBuffer);
                        if(nameLength > MAX_PLAYERNAME_LENGTH) {
                            clearbuffer(receiveBuffer);
                            socket = player.socket;
                            clearbuffer(player.sendBuffer);
                            writebyte(KICK, player.sendBuffer);
                            writebyte(KICK_NAME, player.sendBuffer);
                            sendMessageNonblock(socket, player.sendBuffer);
                            closesocket(socket);
                            break;
                        }
                        else if(bytesleft(receiveBuffer)>=nameLength) {
                            player.name = readchars(nameLength, receiveBuffer);
                            if string_count("#",player.name) > 0 {
                                player.name = "I <3 Bacon";
                            }
                            writebyte(PLAYER_CHANGENAME, global.sendBuffer);
                            writebyte(i, global.sendBuffer);
                            writebyte(string_length(player.name), global.sendBuffer);
                            writechars(player.name, global.sendBuffer);
                            processedUntil = getpos(1, receiveBuffer);
                        } else {
                            hitBufferEnd = true;
                        }  
                    } else {
                        hitBufferEnd = true;
                    }
                    break;
                    
                case INPUTSTATE:
                    if(bytesleft(receiveBuffer)>=3) {
                        if player = global.myself player.authorized = true;
                        if(player.object != -1) && player.authorized == true {
                            player.object.keyState = readbyte(receiveBuffer);
                            player.object.netAimDirection = readshort(receiveBuffer);
                            player.object.aimDirection = player.object.netAimDirection*360/65536;
                        } else {
                            readbyte(receiveBuffer);
                            readshort(receiveBuffer);
                        }
                        if player.authorized == false { //disconnect them
                            socket = player.socket;
                            clearbuffer(player.sendBuffer);
                            closesocket(socket);
                        }
                        processedUntil = getpos(1, receiveBuffer);
                    } else {
                        hitBufferEnd = true;
                    }
                    break; 
            }
        }
        if player.authorized == false && player != global.myself {
            player.passwordCount += 1;
            if player.passwordCount == 30*30 {
                socket = player.socket;
                clearbuffer(player.sendBuffer);
                writebyte(KICK, player.sendBuffer);
                writebyte(KICK_PASSWORDCOUNT, player.sendBuffer);
                sendMessageNonblock(socket, player.sendBuffer);
                closesocket(socket);
            }
        }
        // remove the processed bytes from the buffer        
        if(hitBufferEnd) {
            clearbuffer(global.tempBuffer);
            copybuffer2(global.tempBuffer, processedUntil, buffsize(receiveBuffer)-processedUntil, receiveBuffer);
            clearbuffer(receiveBuffer);
            copybuffer(receiveBuffer, global.tempBuffer);
        } else {
            clearbuffer(receiveBuffer);
        }
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
