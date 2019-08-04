var joiningSocket, joiningPlayer, totalClientNumber;
joiningSocket = socket_accept(global.tcpListener);
if (joiningSocket >= 0)
{
    var ip;
    ip = socket_remote_ip(joiningSocket);

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
            write_ubyte(joiningSocket, KICK);
            write_ubyte(joiningSocket, KICK_MULTI_CLIENT);
            socket_send(joiningSocket);
            socket_destroy(joiningSocket);
            exit;
        }
    }
    
    joiningPlayer = instance_create(0,0,JoiningPlayer);
    joiningPlayer.socket = joiningSocket;
}
