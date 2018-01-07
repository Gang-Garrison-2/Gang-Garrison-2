// Read state data from the global.serverSocket and deserialize it
// argument0: Type of the state update

global.updateType = argument0;

if(argument0 == FULL_UPDATE) {
    receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
    global.tdmInvulnerabilityTicks = read_ushort(global.tempBuffer);
}

receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
if(read_ubyte(global.tempBuffer) != ds_list_size(global.players))
    show_message("Wrong number of players while deserializing state");

if(argument0 != CAPS_UPDATE) {
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        with(player) {
            event_user(13);
        }
    }
    
    with(MovingPlatform)
        event_user(11);
}

if(argument0 == FULL_UPDATE) {
    deserialize(IntelligenceRed);
    deserialize(IntelligenceBlue);
    
    receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
    global.caplimit = read_ubyte(global.tempBuffer);
    global.redCaps = read_ubyte(global.tempBuffer);
    global.blueCaps = read_ubyte(global.tempBuffer);
    global.Server_RespawntimeSec = read_ubyte(global.tempBuffer);
    global.Server_Respawntime = global.Server_RespawntimeSec * 30;
         
    with (HUD)
        event_user(13);
    
    // read in 
    receiveCompleteMessage(global.serverSocket, 10, global.tempBuffer);
    for (a = 0; a < 10; a +=1 )
        global.classlimits[a] = read_ubyte(global.tempBuffer);
}

if(argument0 == CAPS_UPDATE) {
    receiveCompleteMessage(global.serverSocket,3,global.tempBuffer);          
    global.redCaps = read_ubyte(global.tempBuffer);
    global.blueCaps = read_ubyte(global.tempBuffer);
    global.Server_RespawntimeSec = read_ubyte(global.tempBuffer);

    with (HUD)
        event_user(13);
}
