{
    with(Client)
        instance_destroy();
    portForwarded = true;
    if (global.attemptPortForward) {
        upnp_set_description("GG2 (TCP)")
        var discovery_error, forwarding_error;
        discovery_error = upnp_discover(2000);
        if (upnp_error_string(discovery_error) != "") {
            show_message(upnp_error_string(discovery_error))
            portForwarded = false;
        }else{
        forwarding_error = upnp_forward_port(string(global.hostingPort), string(global.hostingPort), "TCP", "0")
            if (upnp_error_string(forwarding_error) != "") {
                show_message(upnp_error_string(forwarding_error))
                portForwarded = false;
            }
        }
    }
    hostSeenMOTD = false;
    global.players = ds_list_create();
    global.tcpListener = -1;
    global.serverSocket = -1;
    
    var i;
    serverId = buffer_create();
    for (i = 0; i < 16; i += 1)
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

    for (a=0; a<10; a+=1)
    {
        if (global.classlimits[a] >= global.playerLimit)
            global.classlimits[a] = 255;
    }
    
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
    if(global.rewardKey != "" and global.rewardId != "")
    {
        var challenge;
        challenge = rewardCreateChallenge();
        rewardAuthStart(serverPlayer, hmac_md5_bin(global.rewardKey, challenge), challenge, false, global.rewardId);
    }
    if(global.queueJumping)
        serverPlayer.queueJump = global.queueJumping;
    
    instance_create(0,0,PlayerControl);

    var map, i;
    if (global.shuffleRotation) {
        ds_list_shuffle(global.map_rotation);
        map = ds_list_find_value(global.map_rotation, 0);
        // "Shuffle, don't make arena map first" chosen
        if (global.shuffleRotation == 1) {
            // if first map is arena
            if (string_copy(map, 0, 6) == 'arena_') {
                // try to find something else
                for (i = 0; i < ds_list_size(global.map_rotation); i += 1) {
                    map = ds_list_find_value(global.map_rotation, i);
                    // swap with first map
                    if (string_copy(map, 0, 6) != 'arena_') {
                        ds_list_replace(global.map_rotation, i, ds_list_find_value(global.map_rotation, 0));
                        ds_list_replace(global.map_rotation, 0, map);
                    }
                }
            }
        }
    }

    currentMapIndex = -1;
    global.currentMapArea = 1;

    serverGotoMap(nextMapInRotation());
    
    global.joinedServerName = global.serverName; // so no errors of unknown variable occur when you create a server
    global.mapchanging = false; 
    
    GameServerDefineCommands();
    
    // load server-sent plugins, if any
    if (string_length(global.serverPluginList))
    {
        // Get hashes of latest versions for plugin list
        pluginList = getpluginhashes(global.serverPluginList);
        if (pluginList == 'failure')
        {
            show_message("Error ocurred getting server-sent plugin hashes.");
            game_end();
            exit;
        }

        // Load plugins
        if (!loadserverplugins(pluginList))
        {
            show_message("Error ocurred loading server-sent plugins.");
            game_end();
            exit;
        }
        global.serverPluginsInUse = true;
    }
    else
    {
        pluginList = '';
    }
    //vsync makes the server desync
    if (global.monitorSync == 1)
    {
        global.monitorSync = 0;
        set_synchronization(0)
    }
}
