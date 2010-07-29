keybyte |= $01;
if(
        global.myself.object.taunting == false &&
        global.myself.object.omnomnomnom == false &&
        global.myself.object.cloak == false &&
        random(9) <= 1) {
    bubbleImage = 50 + global.myself.class;
    clearbuffer(global.sendBuffer);
    writebyte(CHAT_BUBBLE,global.sendBuffer);
    writebyte(bubbleImage,global.sendBuffer);
    sendmessage(global.serverSocket, 0, 0, global.sendBuffer);
}