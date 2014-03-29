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
    
   
    setnagle(global.serverSocket, true);
    setsync(global.serverSocket, 0);
    setformat(global.serverSocket, 2, 0);
        
    clearbuffer(global.sendBuffer);
    ClientPlayerJoin(global.playerName);
    sendmessage(global.serverSocket,0,0,global.sendBuffer);
        
}