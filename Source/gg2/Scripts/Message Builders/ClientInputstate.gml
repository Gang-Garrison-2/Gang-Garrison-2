// Argument 0: Tastenbyte
// Argument 1: Player x
// Argument 2: Player y

writebyte(INPUTSTATE, global.sendBuffer);
writebyte(argument0, global.sendBuffer);
writeshort(point_direction(argument1,argument2, mouse_x, mouse_y)*65536/360, global.sendBuffer);