{
    global.joiningPlayers = ds_list_create();
    global.players = ds_list_create();
    global.sendBuffer = createbuffer();
    global.receiveBuffer = createbuffer();
    global.currentMapIndex = 0;
    randomize();
    global.randomSeed=random_get_seed();
    frame = 0;
    updatePlayer = 1;
    impendingMapChange = -1; // timer variable used by GameServerBeginStep, when it hits 0, the server executes a map change to global.nextMap
    
    if(global.useLobbyServer) {
        lobbysocket = udpconnect(global.hostingPort, 1);
        setformat(lobbysocket, 2, 0);
        lobbyip = hostip(LOBBY_SERVER_HOST);
        if(lobbysocket == -1) {
            show_message("Unable to contact Lobby server");
        }
    } else {
        lobbysocket = -1;
    }
    
    // Player 0 is reserved for the Server.
    serverPlayer = instance_create(0,0,Player);
    serverPlayer.name = global.playerName;
    ds_list_add(global.players, serverPlayer);

    global.tcpListener = tcplisten(global.hostingPort, 2, true);
    global.serverSocket = tcpconnect("127.0.0.1", global.hostingPort, 1);    
    if(global.serverSocket<=0) {
        show_message("Unable to connect to self. Epic fail, dude.");
    }
    setformat(global.serverSocket, 2, 0);
    setnagle(global.serverSocket, true);
    
    do {
        serverPlayer.socket = tcpaccept(global.tcpListener, 0);
        if(serverPlayer.socket>0) {
            setformat(serverPlayer.socket, 2, 0);
            setnagle(serverPlayer.socket, true);
        }
    } until(serverPlayer.socket>0);
    
    global.playerID = 0;
    global.myself = serverPlayer;
    playerControl = instance_create(0,0,PlayerControl);
        
    global.currentMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
    show_message(global.currentMap);
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
                    
    global.mapchanging=0; 
       
}