if(socket_has_error(socket) or (current_time-lastContact > 30000))
{   // Connection closed unexpectedly or timed out, remove client
    socket_destroy(socket);
    instance_destroy();
    exit;
}

if(!tcp_receive(socket, expectedBytes))
    exit;

lastContact = current_time;

var newState;
newState = -1;

switch(state)
{
case STATE_EXPECT_HELLO:
    var sameProtocol, noOfPlayers;
    sameProtocol = (read_ubyte(socket) == HELLO);
    for(i=0; i<16; i+=1)
        if(read_ubyte(socket) != global.protocolUuid[i])
            sameProtocol = false;
            
    if(!sameProtocol)
        write_ubyte(socket, INCOMPATIBLE_PROTOCOL);
    else if(global.serverPassword == "")
    {
        newState = STATE_CLIENT_AUTHENTICATED;
        expectedBytes = 0;
    }
    else
    {
        write_ubyte(socket, PASSWORD_REQUEST);
        newState = STATE_EXPECT_MESSAGELEN;
        messageState = STATE_EXPECT_PASSWORD;
        expectedBytes = 1;
    }
    break;

case STATE_EXPECT_MESSAGELEN:
    expectedBytes = read_ubyte(socket);
    newState = messageState;
    break;

case STATE_EXPECT_PASSWORD:
    if(read_string(socket, expectedBytes) == global.serverPassword)
    {
        newState = STATE_CLIENT_AUTHENTICATED;
        expectedBytes = 0;
    }
    else
        write_ubyte(socket, PASSWORD_WRONG);
    break;

case STATE_CLIENT_AUTHENTICATED:
    write_ubyte(socket, HELLO);
    write_ubyte(socket, string_length(global.serverName));
    write_string(socket, global.serverName);
    newState = STATE_EXPECT_COMMAND;
    expectedBytes = 1;
    break;
    
case STATE_EXPECT_COMMAND:
    switch(read_ubyte(socket))
    {
    case PLAYER_JOIN:
        newState = STATE_EXPECT_MESSAGELEN;
        messageState = STATE_EXPECT_NAME;
        expectedBytes = 1;
        break;
    // Other stuff like RCON_LOGIN can branch off here.
    }
    break;

case STATE_EXPECT_NAME:
    var noOfPlayers, player;
    noOfPlayers = ds_list_size(global.players);
    if(global.dedicatedMode)
        noOfPlayers -= 1;
        
    if(noOfPlayers >= global.playerLimit)
    {
        write_ubyte(socket, SERVER_FULL);
        break;
    }
    
    ServerJoinUpdate(socket);
    
    player = instance_create(0,0,Player);
    player.socket = socket;
    socket = -1;
    
    player.name = read_string(socket, expectedBytes);
    player.name = string_copy(player.name, 0, MAX_PLAYERNAME_LENGTH);
    player.name = string_replace_all(player.name, "#", " ");
    
    ds_list_add(global.players, player);
    ServerPlayerJoin(player.name, global.sendBuffer);
    break;
}

socket_send(socket);
state = newState;
if(state==-1)
{   // We're done, either because of a protocol error or because the client finished joining.
    socket_destroy(socket);
    instance_destroy();
    exit;
}
