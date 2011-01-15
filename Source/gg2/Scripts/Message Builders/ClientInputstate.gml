// Argument 0: Tastenbyte
// Argument 1: Player x
// Argument 2: Player y

write_ubyte(global.sendBuffer, INPUTSTATE);
write_ubyte(global.sendBuffer, argument0);
write_ushort(global.sendBuffer, point_direction(argument1,argument2, mouse_x, mouse_y)*65536/360);
