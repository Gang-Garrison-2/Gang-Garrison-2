var noOfPlayers, serverDescription;
noOfPlayers = ds_list_size(global.players);
if(global.dedicatedMode)
    noOfPlayers -= 1;

serverDescription = "[" + global.currentMap +"] " + global.serverName + " [" + string(noOfPlayers) + "/" + string(global.playerLimit) + "]";
if(global.serverPassword != "")
    serverDescription = "!private!" + serverDescription;

var lobbyBuffer;
lobbyBuffer = buffer_create();

// Magic numbers
write_ubyte(lobbyBuffer, 4);
write_ubyte(lobbyBuffer, 8);
write_ubyte(lobbyBuffer, 15);
write_ubyte(lobbyBuffer, 16);
write_ubyte(lobbyBuffer, 23);
write_ubyte(lobbyBuffer, 42);

// Indicate that a UUID follows
write_ubyte(lobbyBuffer, 128);

// Send version UUID (big endian)
write_buffer(lobbyBuffer, global.protocolUuid);
    
write_ushort(lobbyBuffer, global.hostingPort);
write_ubyte(lobbyBuffer, string_length(serverDescription));
write_string(lobbyBuffer, serverDescription);
udp_send(lobbyBuffer, LOBBY_SERVER_HOST, LOBBY_SERVER_PORT);
buffer_destroy(lobbyBuffer);
