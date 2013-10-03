var socket, joiningPlayer, totalClientNumber;
socket = socket_accept(global.tcpListener);
if(socket >= 0)
{
    var ip;
    ip = socket_remote_ip(socket);

    // Only enforce multiclient limit for non-localhost connections
    if (ip != '127.0.0.1' and ip != '::1')
    {
        // Count number of clients with same IP there will be
        var clientCount;
        clientCount = 1;
        with (Player)
        {
            if (socket_remote_ip(socket) == ip)
                clientCount += 1;
        }
        with (JoiningPlayer)
        {
            if (socket_remote_ip(socket) == ip)
                clientCount += 1;
        }
    
        if (clientCount > global.multiClientLimit)
        {
            // Kick instead of letting join
            write_ubyte(socket, KICK);
            write_ubyte(socket, KICK_MULTI_CLIENT);
            socket_send(socket);
            socket_destroy(socket);
            exit;
        }
    }
    
    joiningPlayer = instance_create(0,0,JoiningPlayer);
    joiningPlayer.socket = socket;
}
