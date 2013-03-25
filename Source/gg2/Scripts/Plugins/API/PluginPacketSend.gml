// Sends a packet for a server-sent plugin to all clients
// argument0 - plugin packet ID, passed as argument0 to server-sent plugin upon execution
// argument1 - data buffer to send

var packetID, buffer;

packetID = argument0;
dataBuffer = argument1;
packetBuffer = buffer_create();

// check to make sure the packet ID is valid
if (ds_map_exists(global.pluginPacketBuffers, packetID))
{
    // send packet to every client (if server), or to server (if client)
    
    // ID of plugin packet container packet
    write_ubyte(packetBuffer, PLUGIN_PACKET);

    // plugin packet ID
    write_ubyte(packetBuffer, packetID);
    
    // plugin packet data buffer
    write_ushort(packetBuffer, buffer_size(dataBuffer));
    write_buffer(packetBuffer, dataBuffer);
    
    // write to appropriate buffer and call send if needed
    if (global.isHost) {
        write_buffer(global.sendBuffer, packetBuffer);
    } else {
        write_buffer(global.serverSocket, packetBuffer);
        socket_send(global.serverSocket);
    }
    buffer_destroy(packetBuffer);
}
else
{
    show_error("ERROR when sending plugin packet: no such plugin packet ID " + string(packetID), true);
}
