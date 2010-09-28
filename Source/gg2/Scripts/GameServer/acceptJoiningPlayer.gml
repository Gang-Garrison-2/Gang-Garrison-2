var socket, joiningPlayer, totalClientNumber;
socket = tcpaccept(global.tcpListener, 1);
if(socket != 0) {
    setformat(socket, 2, 0);
    setnagle(socket, true);
    setsync(socket, 1);
    
    totalClientNumber = instance_number(JoiningPlayer) + ds_list_size(global.players);
    if(totalClientNumber >= global.playerLimit) {
        clearbuffer(0);
        ServerServerFull(0);
        sendMessageNonblock(socket,0);
        closesocket(socket);
    } else {
        joiningPlayer = instance_create(0,0,JoiningPlayer);
        joiningPlayer.socket = socket;
    }
}
