{
    // This function attempts to send a complete buffer.
    // If the message is sent successfully, it returns 0
    // If the socket had to be closed due to an error or loss of connection, it returns 2
    
    // argument 0: Socket
    // argument 1: Buffer
    
    var size, bytesSent;
    bytesSent = 0;
    
    setsync(argument0, 0);
    
    size = sendmessage(argument0, 0, 0, argument1);
    if(size == buffsize(argument1)) {
        return 0;
    } else if (size < 0) {
        closesocket(argument0);
        return 2;
    } else {
        show_message("Sent incomplete data!");
    }    
}