// Sends a packet for a server-sent plugin to all clients
// Returns true if successful, false if not
// argument0 - plugin packet ID, passed as argument1 to server-sent plugin upon execution
// argument1 - data buffer to send (maximum size 65535 bytes)
// argument2 (optional, default false) - boolean, if true will send packet to server as well

var packetID, dataBuffer, loopback, packetBuffer;

packetID = argument0;
dataBuffer = argument1;
loopback = argument2;

// check to make sure the packet ID is valid
if (!ds_map_exists(global.pluginPacketBuffers, packetID))
{
    show_error("ERROR when sending plugin packet: no such plugin packet ID " + string(packetID), true);
    return false;
}

// check size of buffer (limited because ushort used for length of packet)
if (buffer_size(dataBuffer) > 65534)
    return false;

// Short-cicuit when sending to self
if (loopback)
{
    packetBuffer = buffer_create();
    write_buffer(packetBuffer, dataBuffer);
    _PluginPacketPush(packetID, packetBuffer, global.myself);
}

// send packet to every client (if server), or to server (if client)
packetBuffer = buffer_create();

// ID of plugin packet container packet
write_ubyte(packetBuffer, PLUGIN_PACKET);

// packet remainder length
write_ushort(packetBuffer, buffer_size(dataBuffer) + 1);

// plugin packet ID
write_ubyte(packetBuffer, packetID);

// plugin packet data buffer
write_buffer(packetBuffer, dataBuffer);

// write to appropriate buffer and call send if needed
if (global.isHost) {
    write_buffer(global.sendBuffer, packetBuffer);
} else {
    write_buffer(global.serverSocket, packetBuffer);
    socket_send(global.serverSocket);
}

buffer_destroy(packetBuffer);
return true;
