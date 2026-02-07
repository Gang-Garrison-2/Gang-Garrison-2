with(Player)
{
    // server's local player doesn't possess an accompanying Client instance and therefore
    // doesn't perform deserializeState() to read and process it from global.serverSocket
    if (id == global.myself) continue;
    
    write_buffer(socket, global.sendBuffer);
    socket_send(socket);
}
buffer_clear(global.sendBuffer);

global.runningMapDownloads = 0;
global.mapBytesRemainingInStep = global.mapdownloadLimitBps/room_speed;
with(JoiningPlayer)
    if(state==STATE_CLIENT_DOWNLOADING)
        global.runningMapDownloads += 1;

acceptJoiningPlayer();        
with(JoiningPlayer)
    serviceJoiningPlayer();
