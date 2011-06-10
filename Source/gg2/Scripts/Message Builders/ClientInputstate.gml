// Notify the server about the current keystate and aim direction
// Argument 0: Buffer or socket to write to
// Argument 1: the current keybyte

write_ubyte(argument0, INPUTSTATE);
write_ubyte(argument0, argument1);
write_ushort(argument0, point_direction(global.myself.object.x, global.myself.object.y, mouse_x, mouse_y)*65536/360);
