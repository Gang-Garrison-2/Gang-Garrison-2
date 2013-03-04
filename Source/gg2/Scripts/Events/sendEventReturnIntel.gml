/*
argument0: Team of the intel being returned
*/
write_ubyte(global.sendBuffer, RETURN_INTEL);
write_ubyte(global.sendBuffer, argument0);
