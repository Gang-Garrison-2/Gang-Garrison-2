if global.myself.object.intel == false exit;

clearbuffer(global.sendBuffer);
writebyte(DROP_INTEL,global.sendBuffer);
sendmessage(global.serverSocket, 0, 0, global.sendBuffer);