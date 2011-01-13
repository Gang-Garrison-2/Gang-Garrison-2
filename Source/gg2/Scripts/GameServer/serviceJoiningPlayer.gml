var buffer, player;

if(socket_has_error(socket)) {
    // Connection closed unexpectedly, remove client
    instance_destroy();
    exit;
}

buffer = tcp_receive(socket, expectedBytes);
if(buffer >= 0) {
    switch(state) {
    case STATE_EXPECT_HELLO:
        if(read_ubyte(buffer) == PLAYER_JOIN) {
            state = STATE_EXPECT_NAME;
            expectedBytes = read_ubyte(buffer);
        } else {
            socket_destroy(socket, true);
            instance_destroy();
        }
        break;
        
    case STATE_EXPECT_NAME:
        ServerJoinUpdate(socket);
        
        player = instance_create(0,0,Player);
        player.socket = socket;
        
        player.name = read_string(buffer, expectedBytes);
        
        // sanitize player name
        player.name = string_copy(player.name, 0, MAX_PLAYERNAME_LENGTH);
        player.name = string_replace_all(player.name, "#", " ");
        
        //ServerJoinUpdate(player.sendBuffer);
        ds_list_add(global.players, player);
        
        ServerPlayerJoin(player.name, global.sendBuffer);
        
        instance_destroy();
        break;
    }
    buffer_destroy(buffer);
}
