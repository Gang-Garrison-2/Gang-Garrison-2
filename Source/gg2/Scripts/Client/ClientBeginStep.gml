// receive and interpret the server's message(s)
var sockstatus, i, playerObject, playerID, player, otherPlayerID, otherPlayer, sameVersion;

if(global.myself != -1) {
    if(global.myself.object != -1) {
        /*if(lastSentKeystate != playerControl.keybyte) {
            lastSentKeystate = playerControl.keybyte;*/
            clearbuffer(global.sendBuffer);
            ClientInputstate(playerControl.keybyte, global.myself.object.x, global.myself.object.y);
            sendmessage(global.serverSocket,0,0,global.sendBuffer);
        /*}*/
        playerControl.keybyte = 0;
    }
}

roomchange = false;
do {
    setsync(global.serverSocket, 1);
    clearbuffer(0);
    sockstatus = nibbleMessage(global.serverSocket,1,0);
    if(sockstatus == 2) {
        show_message("You have been disconnected from the server.");
        with(all) if id != AudioControl.id instance_destroy();
        room_goto_fix(Menu);
        exit; 
    } else if(sockstatus == 0) {
    switch(readbyte(0)) {
        case HELLO:
                  sameVersion = true;
                  
            receiveCompleteMessage(global.serverSocket,2,0);
            if(readshort(0) != 128) {
                      sameVersion = false;
            } else {
                      receiveCompleteMessage(global.serverSocket,16,0);
                      for(i=0; i<16; i+=1) {
                        if(readbyte(0) != global.protocolUuid[i]) {
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
                receiveCompleteMessage(global.serverSocket,10,0);
                global.playerID = readbyte(0);
                global.randomSeed = readdouble(0);
                      global.currentMapArea = readbyte(0);
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
            receiveCompleteMessage(global.serverSocket,1,0);
            playerID = readbyte(0);
            player = ds_list_find_value(global.players, playerID);
            removePlayer(player);
            if(playerID < global.playerID) {
                global.playerID -= 1;
            }
            break;
                                   
        case PLAYER_DEATH:
            var causeOfDeath;
            receiveCompleteMessage(global.serverSocket,3,0);
            playerID = readbyte(0);
            otherPlayerID = readbyte(0);
                  causeOfDeath = readbyte(0);
                  
            player = ds_list_find_value(global.players, playerID);
                  if(otherPlayerID == 255) {
                      doEventPlayerDeath(player, -1, causeOfDeath);
                  } else {
                      otherPlayer = ds_list_find_value(global.players, otherPlayerID);
                      doEventPlayerDeath(player, otherPlayer, causeOfDeath);
                  }                  
            break;
             
              case BALANCE:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  balanceplayer=readbyte(0);
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
            receiveCompleteMessage(global.serverSocket,2,0);
            player = ds_list_find_value(global.players, readbyte(0));
            if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
            }
            player.team = readbyte(0);
            break;
             
        case PLAYER_CHANGECLASS:
            receiveCompleteMessage(global.serverSocket,2,0);
            player = ds_list_find_value(global.players, readbyte(0));
            if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
            }
            player.class = readbyte(0);
            break;             
        
        case PLAYER_CHANGENAME:
                    receiveCompleteMessage(global.serverSocket,1,0);
            player = ds_list_find_value(global.players, readbyte(0));
            player.name = receivestring(global.serverSocket, 1);
            break;
                 
        case PLAYER_SPAWN:
            receiveCompleteMessage(global.serverSocket,2,0);
            player = ds_list_find_value(global.players, readbyte(0));
            doEventSpawn(player, readbyte(0));
            break;
              
              case CHAT_BUBBLE:
                  var bubbleImage;
                  receiveCompleteMessage(global.serverSocket,2,0);
                  player = ds_list_find_value(global.players, readbyte(0));
                  setChatBubble(player, readbyte(0));
                  break;
             
              case BUILD_SENTRY:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  player = ds_list_find_value(global.players, readbyte(0));
                  if player.sentry == -1 {
                    buildSentry(player);
                  }
                  break;
              
              case DESTROY_SENTRY:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  player = ds_list_find_value(global.players, readbyte(0));
                  if player.sentry != -1 with player.sentry instance_destroy();
                  break;
                      
              case GRAB_INTEL:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  player = ds_list_find_value(global.players, readbyte(0));
                  doEventGrabIntel(player);
                  break;
                  
              case SCORE_INTEL:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  player = ds_list_find_value(global.players, readbyte(0));
                  doEventScoreIntel(player);
                  break;
                  
              case DROP_INTEL:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  player = ds_list_find_value(global.players, readbyte(0));
                  if player.object != -1 {
                    with player.object event_user(5); 
                    }
                  break;
              
              case GENERATOR_DESTROY:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  team = readbyte(0);
                  doEventGeneratorDestroy(team);
                  break;
                  
              case UBER_CHARGED:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  player = ds_list_find_value(global.players, readbyte(0));
                  doEventUberReady(player);
                  break;
              
              case UBER:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  player = ds_list_find_value(global.players, readbyte(0));
                  doEventUber(player);
                  break;    
              
              case OMNOMNOMNOM:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  player = ds_list_find_value(global.players, readbyte(0));
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
                  
              case SCOPE_IN:
                   receiveCompleteMessage(global.serverSocket,1,0);
                   player = ds_list_find_value(global.players, readbyte(0));
                   if player.object != -1 {
                      with player.object {
                           zoomed = true;
                           runPower = 0.6;
                           jumpStrength = 6;
                      }
                   }
                   break;
                        
              case SCOPE_OUT:
                   receiveCompleteMessage(global.serverSocket,1,0);
                   player = ds_list_find_value(global.players, readbyte(0));
                   if player.object != -1 {
                      with player.object {
                           zoomed = false;
                           runPower = 0.9;
                           jumpStrength = 8;
                      }
                   }
                   break;
                                         
              case PASSWORD_REQUEST:             
                    global.clientPassword = get_string("Enter Password:", "");
                    clearbuffer(global.sendBuffer);
                    writebyte(PASSWORD_SEND, global.sendBuffer);
                    writebyte(string_length(global.clientPassword), global.sendBuffer);
                    writechars(global.clientPassword, global.sendBuffer);
                    sendmessage(global.serverSocket,0,0,global.sendBuffer);
                  break;
                   
              case PASSWORD_WRONG:                                    
                  clearbuffer(0);
                  show_message("Incorrect Password.");
                  global.clientPassword = "";
                  with(all) if id != AudioControl.id instance_destroy();
                  room_goto_fix(Lobby);
                  exit;                  
                  break;
              
              case KICK:
                  receiveCompleteMessage(global.serverSocket,1,0);
                  reason = readbyte(0);
                  if reason == KICK_NAME kickReason = "Name Exploit";
                  else if reason == KICK_PASSWORDCOUNT kickReason = "Timed out from not submitting a password";                                    
                  clearbuffer(0);
                  show_message("You have been kicked from the server. "+kickReason+".");
                  with(all) if id != AudioControl.id instance_destroy();
                  room_goto_fix(Lobby);
                  exit;                  
                  break;
              
              case ARENA_ENDROUND:
                  with ArenaHUD clientArenaEndRound();
                  break;   
              
              case ARENA_RESTART:
                  with ArenaHUD {
                    endCount = 0;
                    winners = TEAM_SPECTATOR;
                    roundStart = 300;
                    cpUnlock = 1800;
                    ArenaControlPoint.team = -1;
                    ArenaControlPoint.locked = 1;
                    with Sentry instance_destroy();
                    with SentryGibs instance_destroy();
                  }
                  with Player humiliated = 0;
                  break;
                  
              case ARENA_UNLOCKCP:
                  doEventArenaUnlockCP();
                  break;
              case KOTH_UNLOCKCP:
                  doEventKothUnlockCP();
                  break; 
                         
              case MAP_END:
                  global.nextMap=receivestring(global.serverSocket, 1);
                  receiveCompleteMessage(global.serverSocket,2,0);
                  global.winners=readbyte(0);
                  global.currentMapArea=readbyte(0);
                  if !instance_exists(ScoreTableController) instance_create(0,0,ScoreTableController);
                  instance_create(0,0,WinBanner);
                  break;

        case CHANGE_MAP:
            roomchange=true;
             
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
                        player.kills=0;
                        player.caps=0;
                        player.healpoints=0;
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
    }
} until(sockstatus != 0 or roomchange);

global.clientFrame += 1;
