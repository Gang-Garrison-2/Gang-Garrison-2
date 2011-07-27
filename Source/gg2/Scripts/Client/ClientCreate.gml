{
    // Only one client object may exist at a time
    if(instance_number(object_index)>1) {
        nocreate=true;
        instance_destroy();
        exit;
    }
    nocreate=false;
    
    global.players = ds_list_create();
    global.deserializeBuffer = buffer_create();
    global.isHost = false;

    global.myself = -1;
    playerControl = -1;
    lastSentKeystate = 0;
    
    global.clientFrame = 0;
    global.serverFrame = 0;
    
    global.serverSocket = tcp_connect(global.serverIP, global.serverPort);
    
    write_ubyte(global.serverSocket, HELLO);
    for(i=0; i<16; i+=1) {
        write_ubyte(global.serverSocket, global.protocolUuid[i]);
    }
    socket_send(global.serverSocket);
}
