{
    with(Client)
        instance_destroy();
        
    global.players = ds_list_create();
    global.tcpListener = -1;
    global.serverSocket = -1;
    
    global.currentMapIndex = 0;
    global.currentMapArea = 1;
    
    var i;
    serverId = buffer_create();
    for(i=0;i<16;i+=1)
        write_ubyte(serverId, irandom(255));
    
    serverbalance=0;
    balancecounter=0;
    frame = 0;
    updatePlayer = 1;
    impendingMapChange = -1; // timer variable used by GameServerBeginStep, when it hits 0, the server executes a map change to global.nextMap
    syncTimer = 0; //called in GameServerBeginsStep on CP/intel cap to update everyone with timer/caps/cp status
    
    // Player 0 is reserved for the Server.
    serverPlayer = instance_create(0,0,Player);
    serverPlayer.name = global.playerName;
    ds_list_add(global.players, serverPlayer);

    global.tcpListener = tcp_listen(global.hostingPort);
    if(socket_has_error(global.tcpListener))
    {
        show_message("Unable to host: " + socket_error(global.tcpListener));
        instance_destroy();
        exit;
    }
    global.serverSocket = tcp_connect("127.0.0.1", global.hostingPort);    
    if(socket_has_error(global.serverSocket))
    {
        show_message("Unable to connect to self. Epic fail, dude.");
        instance_destroy();
        exit;
    }
    
    var loopbackStartTime;
    loopbackStartTime = current_time;
    do {
        if(current_time - loopbackStartTime > 500) // 0.5s should be enough to create a loopback connection...
        {
            show_message("Unable to host: Maybe the port is already in use.");
            instance_destroy();
            exit;
        }
        serverPlayer.socket = socket_accept(global.tcpListener);
        io_handle(); // Make sure the game doesn't appear to freeze
    } until(serverPlayer.socket>=0);

    global.playerID = 0;
    global.myself = serverPlayer;
    if(HAXXY_PUBLIC_KEY==md5(global.haxxyKey))
        global.myself.isHaxxyWinner = true;
    instance_create(0,0,PlayerControl);
        
    global.currentMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
    if(file_exists("Maps/" + global.currentMap + ".png")) { // if this is an external map
        // get the md5 and url for the map
        global.currentMapMD5 = CustomMapGetMapMD5(global.currentMap);
        room_goto_fix(CustomMapRoom);
    } else { // internal map, so at the very least, MD5 must be blank
        global.currentMapMD5 = "";
        if(gotoInternalMapRoom(global.currentMap) != 0) {
            show_message("Error:#Map " + global.currentMap + " is not in maps folder, and it is not a valid internal map.#Exiting.");
            game_end();
        }
    }
    
    global.joinedServerName = global.serverName; // so no errors of unknown variable occur when you create a server
    global.mapchanging = false; 
    
    GameServerDefineCommands();
}
