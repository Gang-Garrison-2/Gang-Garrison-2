var player;

if(socket_has_error(socket)) {
    // Connection closed unexpectedly, remove client
    instance_destroy();
    exit;
}

if(tcp_receive(socket, expectedBytes)) {
    switch(state) {
    case STATE_EXPECT_HELLO:
        if(read_ubyte(socket) == PLAYER_JOIN) {
            state = STATE_EXPECT_NAME;
            expectedBytes = read_ubyte(socket);
        } else {
            socket_destroy_abortive(socket);
            instance_destroy();
        }
        break;
        
    case STATE_EXPECT_NAME:
        if(ds_list_size(global.players) >= global.playerLimit) {
            write_ubyte(socket, SERVER_FULL);
            socket_destroy(socket);
            instance_destroy();
        } else {
            ServerJoinUpdate(socket);
            
            player = instance_create(0,0,Player);
            player.socket = socket;
            
            player.name = read_string(socket, expectedBytes);
            
            // sanitize player name
            player.name = string_copy(player.name, 0, MAX_PLAYERNAME_LENGTH);
            player.name = string_replace_all(player.name, "#", " ");
            
            ds_list_add(global.players, player);
            
            ServerPlayerJoin(player.name, global.sendBuffer);
            
            instance_destroy();
        }
        break;
    }
}
