// Returns the Player of the earliest received packet for a server-sent plugin
// If this packet was received from the server, noone is returned instead
// If there is no packet Player to return, returns -1
// argument0 - plugin packet ID, passed as argument1 to server-sent plugin upon execution

var packetID, packetPlayerQueue;

packetID = argument0;

// check to make sure the packet ID is valid
if (!ds_map_exists(global.pluginPacketPlayers, packetID))
{
    show_error("ERROR when fetching plugin packet Player: no such plugin packet ID " + string(packetID), true);
    return noone;
}

packetPlayerQueue = ds_map_find_value(global.pluginPacketPlayers, packetID);

// check we have any Player to return
if (ds_queue_empty(packetPlayerQueue))
    return -1;

return ds_queue_head(packetPlayerQueue);
