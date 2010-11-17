{
    var size,buffer,result;
    buffer = createbuffer();
    receiveCompleteMessage(argument0, argument1, buffer);
    if(argument1 == 1) {
        size = readbyte(buffer);
    } else {
        size = readushort(buffer);
    }
    receiveCompleteMessage(argument0, size, buffer);
    result = readchars(size, buffer);
    freebuffer(buffer);
    return result;
}
