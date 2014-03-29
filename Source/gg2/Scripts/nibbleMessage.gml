{
    // This function attempts to read a message of the length given in arg1.
    // If the message is received completely, it returns 0
    // If the message is not yet received completely, it returns 1
    // If the socket had to be closed due to an error or loss of connection, it returns 2
    // The buffer should be cleared before calling this for the first time.
    // The buffer's read position is retained, its write position is not.
    
    // argument 0: Socket
    // argument 1: size of the message to receive
    // argument 2: Buffer
    
    var size, inBufSize, readpos;
    
    inBufSize = buffsize(argument2);    
    if(inBufSize >= argument1) {
        return 0;
    }
    
    if(inBufSize == 0) {
        size = receivemessage(argument0, argument1, argument2);
    } else {
        size = receivemessage(argument0, argument1-inBufSize, global.tempBuffer);
        if(size > 0) {
            readpos = getpos(1, argument2);
            setpos(inBufSize, argument2);
            copybuffer2(argument2, 0, size, global.tempBuffer);
            setpos(readpos, argument2);
        }
    }
    
    if(size > 0) {
        if(buffsize(argument2) >= argument1) {
            return 0;
        } else {
            return 1;
        }
    } else {
        switch(size) {
            case WSAEWOULDBLOCK:
                return 1;
            
            /*case 0:
            case WSAENETDOWN:
            case WSAENOTCONN:
            case WSAENETRESET:
            case WSAESHUTDOWN:
            case WSAECONNABORTED:
            case WSAETIMEDOUT:
            case WSAECONNRESET:*/
            default:
                closesocket(argument0);
                return 2;
        }
    }
}