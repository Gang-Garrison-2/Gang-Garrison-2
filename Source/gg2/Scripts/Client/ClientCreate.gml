{
    // Only one client object may exist at a time
    if(instance_number(object_index)>1) {
        nocreate=true;
        instance_destroy();
        exit;
    }
    nocreate=false;
    
    global.players = ds_list_create();
    global.deserializeBuffer = createbuffer();
    global.isHost = false;
    global.randomSeed=0;

    global.myself = -1;
    playerControl = -1;
    lastSentKeystate = 0;
    
    global.clientFrame = 0;
    global.serverFrame = 0;
    
    global.serverSocket = tcpconnect(global.serverIP, global.serverPort, true);
    if(global.serverSocket<=0) {
        show_message("Connection failed.");
        instance_destroy();
        exit;
    }
    
    //Uses the lobby name to create a global variable for use with scoreboard
    //deletes the part up to "] ", which is the end of the map listing
    global.joinedServerName = string_delete(global.joinedServerName, 1, string_pos("] ", global.joinedServerName) + 1);
    //takes the part before " [", or the player list, leaving the server name
    //First, see if there's any other brackets in the name (/v/idya [US west]) by counting them, 
    //then keeps checking until [%/%] is left, and takes the size
    var tempServName;
    if(string_count(" [",global.joinedServerName) > 1){
        tempServName = global.joinedServerName;
        while(string_count("[", tempServName) > 1)
            tempServName = string_delete(tempServName, 1, string_pos(" [", tempServName) + 1);
        tempServName = string_delete(tempServName, 1, string_pos(" [", tempServName));
        global.joinedServerName = string_copy(global.joinedServerName, 1, string_length(global.joinedServerName) - string_length(tempServName));
    }
    else global.joinedServerName = string_copy(global.joinedServerName, 1, string_pos(" [", global.joinedServerName) - 1);
    
   
    setnagle(global.serverSocket, true);
    setsync(global.serverSocket, 0);
    setformat(global.serverSocket, 2, 0);
        
    clearbuffer(global.sendBuffer);
    ClientPlayerJoin(global.playerName);
    sendmessage(global.serverSocket,0,0,global.sendBuffer);
        
}
