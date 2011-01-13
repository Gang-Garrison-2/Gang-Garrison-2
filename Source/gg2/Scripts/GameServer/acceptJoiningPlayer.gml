var socket, joiningPlayer, totalClientNumber;
socket = socket_accept(global.tcpListener);
if(socket != 0) {
    totalClientNumber = instance_number(JoiningPlayer) + ds_list_size(global.players);
    if(totalClientNumber >= global.playerLimit) {
        ServerServerFull(socket);
        socket_destroy(socket, false);
    } else {
        joiningPlayer = instance_create(0,0,JoiningPlayer);
        joiningPlayer.socket = socket;
    }
}
