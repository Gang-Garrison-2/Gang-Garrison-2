var socket, joiningPlayer, totalClientNumber;
socket = socket_accept(global.tcpListener);
if(socket >= 0) {
    joiningPlayer = instance_create(0,0,JoiningPlayer);
    joiningPlayer.socket = socket;
}
