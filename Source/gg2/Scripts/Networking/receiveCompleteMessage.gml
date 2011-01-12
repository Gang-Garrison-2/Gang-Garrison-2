{
    // This function attempts to read a message of the length given in arg1.
    // It won't return unless the complete message is read or an error occurs.
    
    // If the message is received completely, it returns 0
    // If the socket had to be closed due to an error or loss of connection, it returns 2
    // If there was some other error (probably wrong arguments), it returns 3
    
    // The given buffer will be cleared before reading the message.
    // The socket will be set to blocking mode.
    
    // argument 0: Socket
    // argument 1: size of the message to receive
    // argument 2: Buffer
    
    var buffer;
    buffer_clear(argument2);
    
    do {
        if(socket_has_error(argument0)) {
            return 2;
        }
        buffer = tcp_receive(argument0, argument1);
    } until(buffer >= 0);
    
    write_buffer(argument2, buffer);
    buffer_destroy(buffer);
    
    return 0;
}
