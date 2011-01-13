var player, playerId;

player = argument0;
playerId = argument1;

while(true) {
    var buffer, command;
    buffer = tcp_receive(player.socket, 1);
    if(buffer < 0) {
        return;
    }
    command = read_ubyte(buffer);
    buffer_destroy(buffer);
    switch(commandByte) {
        case PLAYER_HAT:
            // Dummy command that does nothing
            // Added for compatibility with the xmas2010 version.
            // Can be removed any time after the next protocol change.
            break;
        
        case PLAYER_LEAVE:
            socket_destroy(player.socket, false);
            player.socket = -1;
            break;
            
        case PLAYER_CHANGECLASS:
            var class;
            class = read_ubyte(buffer);
            if(getCharacterObject(player.team, class) != -1) {
                player.class = class;
                if(player.object != -1) {
                    with(player.object) {
                        instance_destroy();
                    }
                    player.object = -1;
                    if (player.quickspawn==0){
                        player.alarm[5] = global.Server_Respawntime;
                    } else {
                        player.alarm[5] = 1;
                    }    
                } else if(player.alarm[5]<=0) {
                    player.alarm[5] = 1;
                }
                ServerPlayerChangeclass(playerId, player.class, global.sendBuffer);
            }
            break;
            
        case PLAYER_CHANGETEAM:
            var team;
            team = read_ubyte(buffer);
            if(getCharacterObject(team, player.class) != -1 or team==TEAM_SPECTATOR) {  
                if(player.object != -1) {
                    with(player.object) {
                        instance_destroy();
                    }
                    player.object = -1;
                    player.alarm[5] = global.Server_Respawntime;
                } else if(player.alarm[5]<=0) {
                    player.alarm[5] = 1;
                }
                player.team = team;
                ServerPlayerChangeteam(playerId, player.team, global.sendBuffer);
            }
            break;                   
            
        case CHAT_BUBBLE:
            var bubbleImage;
            bubbleImage = read_ubyte(buffer);
            if(global.aFirst) {
                bubbleImage = 0;
            }
            write_ubyte(global.sendBuffer, CHAT_BUBBLE);
            write_ubyte(global.sendBuffer, playerId);
            write_ubyte(global.sendBuffer, bubbleImage);
            
            setChatBubble(player, bubbleImage);
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
            if(player.object != -1) {
                if(player.humiliated == 0
                        && player.object.taunting==false
                        && player.object.omnomnomnom==false
                        && player.class==CLASS_HEAVY) {                            
                    writebyte(OMNOMNOMNOM, global.sendBuffer);
                    writebyte(i, global.sendBuffer);
                    with(player.object) {
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
