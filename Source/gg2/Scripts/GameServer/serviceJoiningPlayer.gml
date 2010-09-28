var status, player;

status = nibbleMessage(socket, expectedBytes, receiveBuffer);
if(status==2) {
    // Connection closed unexpectedly, remove client
    instance_destroy();
} else if(status==0) {
    switch(state) {
    case STATE_EXPECT_HELLO:
        if(readbyte(receiveBuffer) == PLAYER_JOIN) {
            state = STATE_EXPECT_NAME;
            expectedBytes = readbyte(receiveBuffer);
        } else {
            closesocket(socket);
            instance_destroy();
        }
        break;
        
    case STATE_EXPECT_NAME:
        clearbuffer(0);
        ServerJoinUpdate(0);
        
        player = instance_create(0,0,Player);
        player.socket = socket;
        
        player.name = readchars(expectedBytes, receiveBuffer);
        
        // sanitize player name
        player.name = string_copy(player.name, 0, MAX_PLAYERNAME_LENGTH);
        player.name = string_replace_all(player.name, "#", " ");
        
        //ServerJoinUpdate(player.sendBuffer);
        ds_list_add(global.players, player);
        
        sendMessageNonblock(socket, 0);
        copybuffer(player.sendBuffer, 0);
        
        ServerPlayerJoin(player.name, global.sendBuffer);
        
        instance_destroy();
        break;
    }
    clearbuffer(receiveBuffer);
}
