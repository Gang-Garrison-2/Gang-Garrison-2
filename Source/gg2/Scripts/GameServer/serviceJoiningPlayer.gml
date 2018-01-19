if(socket_has_error(socket) or (current_time-lastContact > 30000) or kicked)
{   // Connection closed unexpectedly or timed out, remove client
    socket_destroy(socket);
    instance_destroy();
    exit;
}

if(state==STATE_CLIENT_DOWNLOADING)
{
    lastContact = current_time;
    cumulativeMapBytes += global.mapdownloadLimitBps/(room_speed*global.runningMapDownloads);
    if(cumulativeMapBytes>=400 and global.mapBytesRemainingInStep>0)
    {
        var bytesToSend;
        bytesToSend = round(min(max(global.mapBytesRemainingInStep, 400), cumulativeMapBytes));
        write_buffer_part(socket, mapDownloadBuffer, bytesToSend);
        socket_send(socket);
        global.mapBytesRemainingInStep -= bytesToSend;
        cumulativeMapBytes -= bytesToSend;
        if(!buffer_bytes_left(mapDownloadBuffer))
        {
            buffer_destroy(mapDownloadBuffer);
            mapDownloadBuffer = -1;
            state = STATE_EXPECT_COMMAND;
            expectedBytes = 1;
        }
    }
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
    buffer_set_readpos(global.protocolUuid, 0)
    for(i=0; i<4; i+=1)
        if(read_uint(socket) != read_uint(global.protocolUuid))
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
    write_ubyte(socket, string_length(global.currentMap));
    write_string(socket, global.currentMap);
    write_ubyte(socket, string_length(global.currentMapMD5));
    write_string(socket, global.currentMapMD5);
    
    write_ubyte(socket, global.serverPluginsRequired);
    write_ushort(socket, string_length(GameServer.pluginList));
    write_string(socket, GameServer.pluginList);
    
    advertisedMap = global.currentMap;
    advertisedMapMd5 = global.currentMapMD5;
    newState = STATE_EXPECT_COMMAND;
    expectedBytes = 1;
    break;
    
case STATE_EXPECT_COMMAND:
    switch(read_ubyte(socket))
    {
    // keeps connection open when downloading plugins
    case PING:
        newState = STATE_EXPECT_COMMAND;
        expectedBytes = 1;
        break;

    case PLAYER_JOIN:
        if(!occupiesSlot)
        {
            // RESERVE_SLOT is required first
            break;
        }
        
        ServerJoinUpdate(socket);
    
        player = instance_create(0,0,Player);
        player.socket = socket;
        socket = -1; // Prevent the socket from being destroyed with the JoiningPlayer - it belongs to the Player now.
        
        player.name = name;
        
        ds_list_add(global.players, player);
        ServerPlayerJoin(player.name, global.sendBuffer);
        
        if(global.welcomeMessage != "")
            ServerMessageString(global.welcomeMessage, player.socket);
    
        break;
        
    case DOWNLOAD_MAP:
        if(advertisedMapMd5 != "" and file_exists("Maps/" + advertisedMap + ".png"))
        {   // If the md5 was empty, we advertised an internal map, which obviously can't be downloaded.
            buffer_destroy(mapDownloadBuffer);
            mapDownloadBuffer = buffer_create();
            if(!append_file_to_buffer(mapDownloadBuffer, "Maps/" + advertisedMap + ".png")) {
                buffer_destroy(mapDownloadBuffer);
                mapDownloadBuffer = -1;
                break;
            }
            write_uint(socket, buffer_size(mapDownloadBuffer));
            newState = STATE_CLIENT_DOWNLOADING;
        }
        break;
        
    // Indicate that we want to join, but we still have to download the map / apply plugins / whatever
    // and we don't want to do that just to be greeted with a "Server is full" message.
    // RESERVE_SLOT is required before you can use PLAYER_JOIN, but PING and DOWNLOAD_MAP don't require it.
    case RESERVE_SLOT:
        newState = STATE_EXPECT_MESSAGELEN;
        messageState = STATE_EXPECT_NAME;
        expectedBytes = 1;
        break;
        
    // Other stuff like RCON_LOGIN can branch off here.
    }
    break;

case STATE_EXPECT_NAME:
    var noOfOccupiedSlots, player;
    noOfOccupiedSlots = getNumberOfOccupiedSlots();
        
    if(noOfOccupiedSlots >= global.playerLimit)
    {
        write_ubyte(socket, SERVER_FULL);
        break;
    }

    // message lobby to update playercount if we became full
    if(noOfOccupiedSlots+1 == global.playerLimit)
        sendLobbyRegistration();
        
    occupiesSlot = true;

    name = read_string(socket, expectedBytes);
    name = string_copy(name, 0, MAX_PLAYERNAME_LENGTH);
    
    write_ubyte(socket, RESERVE_SLOT);
    
    newState = STATE_EXPECT_COMMAND;
    expectedBytes = 1;
    break;
}

socket_send(socket);
state = newState;
if(state==-1)
{   // We're done, either because of a protocol error or because the client finished joining.
    instance_destroy();
    exit;
}
