if (!global.myself.object.intel)
    exit;

write_byte(global.serverSocket, DROP_INTEL);
