/*
argument0: Team of the intel being returned
*/
write_ubyte(global.eventBuffer, RETURN_INTEL);
write_ubyte(global.eventBuffer, argument0);
