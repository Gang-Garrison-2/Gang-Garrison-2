// Returns the buffer of the earliest received packet for a server-sent plugin
// Buffer returned should not be modified or destroyed.
// If there is no packet buffer to return, returns -1
// argument0 - plugin packet ID, passed as argument1 to server-sent plugin upon execution

var packetID, packetBufferQueue;

packetID = argument0;

// check to make sure the packet ID is valid
if (!ds_map_exists(global.pluginPacketBuffers, packetID))
{
    show_error("ERROR when fetching plugin packet buffer: no such plugin packet ID " + string(packetID), true);
    return -1;
}

packetBufferQueue = ds_map_find_value(global.pluginPacketBuffers, packetID);

// check we have any buffer to return
if (ds_queue_empty(packetBufferQueue))
    return -1;

return ds_queue_head(packetBufferQueue);
