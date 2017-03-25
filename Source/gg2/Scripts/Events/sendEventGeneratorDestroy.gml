/**
 * argument0: The team who destroyed the bomb
 */
 
write_ubyte(global.sendBuffer, GENERATOR_DESTROY);
write_ubyte(global.sendBuffer, argument0);
