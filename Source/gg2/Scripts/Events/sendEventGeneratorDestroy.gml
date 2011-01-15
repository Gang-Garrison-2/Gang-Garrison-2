/**
 * argument0: The team who destroyed the bomb
 */
 
write_ubyte(global.eventBuffer, GENERATOR_DESTROY);
write_ubyte(global.eventBuffer, argument0);
