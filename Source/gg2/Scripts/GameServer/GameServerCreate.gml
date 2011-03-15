{
    maxplayers = global.playerLimit;
    if global.dedicatedMode == 1 { 
        global.playerLimit += 1;
    }
    //Vindicator
    global.buffer_team = TEAM_SPECTATOR;
    global.buffer_switch = false;
    global.buffer_all = buffer_create();
    global.buffer_red = buffer_create();
    global.buffer_blue = buffer_create();
    ////
    global.joiningPlayers = ds_list_create();
    global.players = ds_list_create();
    global.currentMapIndex = 0;
    serverbalance=0;
    balancecounter=0;
    randomize();
    global.randomSeed=random_get_seed();
    frame = 0;
    updatePlayer = 1;
    impendingMapChange = -1; // timer variable used by GameServerBeginStep, when it hits 0, the server executes a map change to global.nextMap
    syncTimer = 0; //called in GameServerBeginsStep on CP/intel cap to update everyone with timer/caps/cp status
    
    // Player 0 is reserved for the Server.
    serverPlayer = instance_create(0,0,Player);
    serverPlayer.name = global.playerName;
    ds_list_add(global.players, serverPlayer);

    global.tcpListener = tcp_listen(global.hostingPort);
    global.serverSocket = tcp_connect("127.0.0.1", global.hostingPort);    
    if(socket_has_error(global.serverSocket)) {
        show_message("Unable to connect to self. Epic fail, dude.");
    }
    
    do {
        serverPlayer.socket = socket_accept(global.tcpListener);
        if(keyboard_check(vk_escape)) {
        show_message("Exited");
        game_end();
        exit;
      }
    } until(serverPlayer.socket>=0);
    //show_message("END")
    global.playerID = 0;
    global.myself = serverPlayer;
    global.myself.authorized = true;
    playerControl = instance_create(0,0,PlayerControl);
        
    global.currentMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
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
    
    global.joinedServerName = global.serverName; // so no errors of unknown variable occur when you create a server
                    
    global.mapchanging=0; 
    
    global.blu_next_map = false;
    global.red_next_map = false;        
    global.blu_next_map_back = false;
    global.red_next_map_back = false;
    global.red_next_map_temp = false;
    global.red_next_map_temp = false;
    global.nextmap_temp_blu_back = false;
    global.nextmap_temp_red_back = false;
    
    GameServerDefineCommands();
}
