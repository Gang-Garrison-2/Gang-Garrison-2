if(
        global.myself.object.taunting == false &&
        global.myself.object.omnomnomnom == false &&
        global.myself.object.cloak == false &&
        global.myself.humiliated == false &&
        random(9) <= 1) {
    bubbleImage = 50 + global.myself.class;
    write_ubyte(global.serverSocket, CHAT_BUBBLE);
    write_ubyte(global.serverSocket, bubbleImage);
}
