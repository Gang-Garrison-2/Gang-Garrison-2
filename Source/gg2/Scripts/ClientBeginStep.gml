// receive and interpret the server's message(s)
var sockstatus, i, playerObject, playerID, player, otherPlayerID, otherPlayer;

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
        room_goto_fix(Menu);
        instance_destroy();
        exit; 
    } else if(sockstatus == 0) {
	    switch(readbyte(0)) {
	        case HELLO:
	            show_debug_message("Got HELLO");
	            receiveCompleteMessage(global.serverSocket,2,0);
	            if(readshort(0) == PROTOCOL_VERSION) {
	                receiveCompleteMessage(global.serverSocket,9,0);
	                global.playerID = readbyte(0);
	                global.randomSeed = readdouble(0);
	            } else {
	                show_message("Incompatible server protocol version.");
	                room_goto_fix(Menu);
	                instance_destroy();                 
	                exit; 
	            }
	            break;
	        
	        case FULL_UPDATE:
                  deserializeState(FULL_UPDATE);
                  break;
	        
	        case QUICK_UPDATE:
                  deserializeState(QUICK_UPDATE);
	            global.serverFrame += 1;
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
	            if(player.object != -1) {
                      player.object.lastDamageSource = causeOfDeath;
	                with(player.object) {
	                    event_user(9);
	                }
	            }
	            
	            player.deaths += 1;
	            

	            if(otherPlayerID != 255 and otherPlayerID != playerID) {
	                otherPlayer = ds_list_find_value(global.players, otherPlayerID);
	                otherPlayer.kills += 1;
                      recordKillInLog(player, otherPlayer, causeOfDeath);
	            } else {
                      recordKillInLog(player, -1, causeOfDeath);
                  }

	            break;
	            
	        case PLAYER_CHANGETEAM:
	            receiveCompleteMessage(global.serverSocket,2,0);
	            var playernr;
	            playernr = readbyte(0);

	            player = ds_list_find_value(global.players, playernr);
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
	            
	        case PLAYER_SPAWN:
	            receiveCompleteMessage(global.serverSocket,2,0);
	            player = ds_list_find_value(global.players, readbyte(0));
	            spawnPlayer(player, readbyte(0));
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
                  buildSentry(player);
                  break;
                  
              case MAP_END:
                  {
                  global.nextMap=receivestring(global.serverSocket, 1);
                  mapEnd();
                  }
                  break;

	        case CHANGE_MAP:
	            roomchange=true;
             
	            global.currentMap = receivestring(global.serverSocket, 1);
                  global.currentMapURL = receivestring(global.serverSocket, 1);
                  global.currentMapMD5 = receivestring(global.serverSocket, 1);
                  if(global.currentMapMD5 == "") { // if this is an internal map (signified by the lack of an md5)
                      gotoInternalMapRoom(global.currentMap);
                  } else { // it's an external map
                      room_goto_fix(CustomMapLoadingScreen);
	            }
                 for(i=0; i<ds_list_size(global.players); i+=1) {
                 player = ds_list_find_value(global.players, i);
                 player.kills=0;
                 player.caps=0;
                 player.healpoints=0;
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