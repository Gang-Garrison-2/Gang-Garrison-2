{
    // This function attempts to send a buffer.
    // All bytes successfully written will be cleared from the buffer.
    // If the buffer is sent completely, it returns 0
    // If the buffer is sent partially, it returns 1
    // If the socket had to be closed due to an error or loss of connection, it returns 2
    
    // argument 0: Socket
    // argument 1: Buffer
    
    var size;
    
    setsync(argument0, 1);
    
    size = sendmessage(argument0, 0, 0, argument1);
    if(size == buffsize(argument1)) {
        clearbuffer(argument1);
        return 0;
    } else if (size < 0) {
        switch(size) {
            case WSAENOBUFS:
            case WSAEWOULDBLOCK:
                if(buffsize(argument1)>100000) {
                    closesocket(argument0);
                    return 2;
                } else {
                    return 1;   
                }
                
            default:
                closesocket(argument0);
                return 2;
        }
    } else if(size < buffsize(argument1)) {
        if(buffsize(argument1)-size>100000) {
            closesocket(argument0);
            return 2;
        } else {
            clearbuffer(global.tempBuffer);
            copybuffer2(global.tempBuffer, size, buffsize(argument1)-size, argument1);
            clearbuffer(argument1);
            copybuffer(argument1, global.tempBuffer);
            return 1;
        }
    }    
}