// receive and interpret the server's message(s)
var i, playerObject, playerID, player, otherPlayerID, otherPlayer, sameVersion, buffer;

roomchange = false;
do {
    if(socket_has_error(global.serverSocket)) {
        show_message("You have been disconnected from the server.");
        with(all) if id != AudioControl.id instance_destroy();
        room_goto_fix(Menu);
        exit; 
    }
    if(tcp_receive(global.serverSocket,1)) {
        switch(read_ubyte(global.serverSocket)) {
        case HELLO:
            sameVersion = true;
                  
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            if(read_ushort(global.tempBuffer) != 128) {
                sameVersion = false;
            } else {
                receiveCompleteMessage(global.serverSocket,16,global.tempBuffer);
                for(i=0; i<16; i+=1) {
                    if(read_ubyte(global.tempBuffer) != global.protocolUuid[i]) {
                        sameVersion = false;
                    }
                }
            }

            if(not sameVersion) {
                show_message("Incompatible server protocol version.");
                with(all) if id != AudioControl.id instance_destroy();
                room_goto_fix(Menu);
                exit;
            } else {
                receiveCompleteMessage(global.serverSocket,10,global.tempBuffer);
                global.playerID = read_ubyte(global.tempBuffer);
                global.randomSeed = read_double(global.tempBuffer);
                global.currentMapArea = read_ubyte(global.tempBuffer);
            }
            break;
        
        case FULL_UPDATE:
            deserializeState(FULL_UPDATE);
            break;
        
        case QUICK_UPDATE:
            deserializeState(QUICK_UPDATE);
            global.serverFrame += 1;
            break;
             
        case CAPS_UPDATE:
            deserializeState(CAPS_UPDATE);
            break;
                  
        case INPUTSTATE:
            deserializeState(INPUTSTATE);
            global.serverFrame += 1;
            break;             
        
        case PLAYER_JOIN:
            player = instance_create(0,0,Player);
            player.name = receivestring(global.serverSocket, 1);
                  
            ds_list_add(global.players, player);
            if(ds_list_size(global.players)-1 == global.playerID) {
                global.myself = player;
                playerControl = instance_create(0,0,PlayerControl);
            }
            break;
            
        case PLAYER_LEAVE:
            // Delete player from the game, adjust own ID accordingly
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            playerID = read_ubyte(global.tempBuffer);
            player = ds_list_find_value(global.players, playerID);
            removePlayer(player);
            if(playerID < global.playerID) {
                global.playerID -= 1;
            }
            break;
                                   
        case PLAYER_DEATH:
            var causeOfDeath, assistantPlayerID, assistantPlayer;
            receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
            playerID = read_ubyte(global.tempBuffer);
            otherPlayerID = read_ubyte(global.tempBuffer);
            assistantPlayerID = read_ubyte(global.tempBuffer);
            causeOfDeath = read_ubyte(global.tempBuffer);
                  
            player = ds_list_find_value(global.players, playerID);
            
            otherPlayer = noone;
            if(otherPlayerID != 255)
                otherPlayer = ds_list_find_value(global.players, otherPlayerID);
            
            assistantPlayer = noone;
            if(assistantPlayerID != 255)
                assistantPlayer = ds_list_find_value(global.players, assistantPlayerID);
            
            doEventPlayerDeath(player, otherPlayer, assistantPlayer, causeOfDeath);
            break;
             
        case BALANCE:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            balanceplayer=read_ubyte(global.tempBuffer);
                  if balanceplayer == 255 {
                    if !instance_exists(Balancer) instance_create(x,y,Balancer);
                    with(Balancer) notice=0;
                  } else {
                    player = ds_list_find_value(global.players, balanceplayer);
                    if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
              }
              if(player.team==TEAM_RED) {
                        player.team = TEAM_BLUE;
                    } else {
                        player.team = TEAM_RED;
                    }
                    if !instance_exists(Balancer) instance_create(x,y,Balancer);
                    Balancer.name=player.name;
                    with (Balancer) notice=1;
                  }
                  break;
                  
        case PLAYER_CHANGETEAM:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
            }
            player.team = read_ubyte(global.tempBuffer);
            break;
             
        case PLAYER_CHANGECLASS:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
            }
            player.class = read_ubyte(global.tempBuffer);
            break;             
        
        case PLAYER_CHANGENAME:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            player.name = receivestring(global.serverSocket, 1);
            if player=global.myself {
            global.playerName=player.name
            }
            break;
                 
        case PLAYER_SPAWN:
            receiveCompleteMessage(global.serverSocket,3,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventSpawn(player, read_ubyte(global.tempBuffer), read_ubyte(global.tempBuffer));
            break;
              
        case CHAT_BUBBLE:
            var bubbleImage;
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            setChatBubble(player, read_ubyte(global.tempBuffer));
            break;
             
        case BUILD_SENTRY:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.sentry == -1 {
              buildSentry(player);
            }
            break;
              
        case DESTROY_SENTRY:
            receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
            playerID = read_ubyte(global.tempBuffer);
            otherPlayerID = read_ubyte(global.tempBuffer);
            assistantPlayerID = read_ubyte(global.tempBuffer);
            causeOfDeath = read_ubyte(global.tempBuffer);
            
            player = ds_list_find_value(global.players, playerID);
            if(otherPlayerID == 255) {
                doEventDestruction(player, -1, -1, causeOfDeath);
            } else {
                otherPlayer = ds_list_find_value(global.players, otherPlayerID);
                if (assistantPlayerID == 255) {
                   doEventDestruction(player, otherPlayer, -1, causeOfDeath);
                } else {
                   assistantPlayer = ds_list_find_value(global.players, assistantPlayerID);
                   doEventDestruction(player, otherPlayer, assistantPlayer, causeOfDeath);
                }
            }
            break;
                      
        case GRAB_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventGrabIntel(player);
            break;
      
        case SCORE_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventScoreIntel(player);
            break;
      
        case DROP_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.object != -1 {
                with player.object event_user(5); 
            }
            break;
  
        case GENERATOR_DESTROY:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            team = read_ubyte(global.tempBuffer);
            doEventGeneratorDestroy(team);
            break;
      
        case UBER_CHARGED:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventUberReady(player);
            break;
  
        case UBER:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventUber(player);
            break;    
  
        case OMNOMNOMNOM:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if(player.object != -1) {
              with(player.object) {
                  omnomnomnom=true;
                  if(player.team == TEAM_RED) {
                      omnomnomnomindex=0;
                      omnomnomnomend=31;
                  } else if(player.team==TEAM_BLUE) {
                      omnomnomnomindex=32;
                      omnomnomnomend=63;
                  }
                  xscale=image_xscale; 
              } 
            }
            break;
      
        case TOGGLE_ZOOM:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.object != -1 {
                toggleZoom(player.object);
            }
            break;
                                         
        case PASSWORD_REQUEST:             
            global.clientPassword = get_string("Enter Password:", "");
            write_ubyte(global.serverSocket, PASSWORD_SEND);
            write_ubyte(global.serverSocket, string_length(global.clientPassword));
            write_string(global.serverSocket, global.clientPassword);
            break;
       
        case PASSWORD_WRONG:                                    
            show_message("Incorrect Password.");
            global.clientPassword = "";
            with(all) if id != AudioControl.id instance_destroy();
            room_goto_fix(Lobby);
            exit;                  
            break;
              
        case KICK:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            reason = read_ubyte(global.tempBuffer);
            if reason == KICK_NAME kickReason = "Name Exploit";
            else if reason == KICK_PASSWORDCOUNT kickReason = "Timed out from not submitting a password";                                    
            show_message("You have been kicked from the server. "+kickReason+".");
            with(all) if id != AudioControl.id instance_destroy();
            room_goto_fix(Lobby);
            exit;                  
            break;
              
        case ARENA_ENDROUND:
            with ArenaHUD clientArenaEndRound();
            break;   
        
        case ARENA_RESTART:
            doEventArenaRestart();
            break;
            
        case UNLOCKCP:
            doEventUnlockCP();
            break;
                   
        case MAP_END:
            global.nextMap=receivestring(global.serverSocket, 1);
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            global.winners=read_ubyte(global.tempBuffer);
            global.currentMapArea=read_ubyte(global.tempBuffer);
            global.mapchanging = 1;
            if !instance_exists(ScoreTableController) instance_create(0,0,ScoreTableController);
            instance_create(0,0,WinBanner);
            break;

        case CHANGE_MAP:
            roomchange=true;
            global.mapchanging = 0
            global.currentMap = receivestring(global.serverSocket, 1);
            global.currentMapURL = receivestring(global.serverSocket, 1);
            global.currentMapMD5 = receivestring(global.serverSocket, 1);
            if(global.currentMapMD5 == "") { // if this is an internal map (signified by the lack of an md5)
                if(gotoInternalMapRoom(global.currentMap) != 0) {
                    show_message("Error:#Server went to invalid internal map: " + global.currentMap + "#Exiting.");
                    game_end();
                }
            } else { // it's an external map
                CustomMapDownload();
            }
                 
            for(i=0; i<ds_list_size(global.players); i+=1) {
                player = ds_list_find_value(global.players, i);
                if global.currentMapArea == 1 { 
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
            }
            break;
        
        case SERVER_FULL:
            show_message("The server is full.");
            instance_destroy();
            exit;
                              
        default:
            show_message("The Server sent unexpected data");
            game_end();
            exit; 
        }
    } else {
        break;
    }
} until(roomchange);

global.clientFrame += 1;
