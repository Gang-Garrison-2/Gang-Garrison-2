{
    var size;
    receiveCompleteMessage(argument0, argument1, global.receiveBuffer);
    if(argument1 == 1) {
        size = readbyte(global.receiveBuffer);
    } else {
        size = readushort(global.receiveBuffer);
    }
    receiveCompleteMessage(argument0, size, global.receiveBuffer);
    return readchars(size, global.receiveBuffer);
}