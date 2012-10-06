// argument0 - mapname
// argument1 - mapmd5
// argument2 - buffer

write_ubyte(argument2, CHANGE_MAP);
write_ubyte(argument2, string_length(argument0));
write_string(argument2, argument0);
write_ubyte(argument2, string_length(argument1));
write_string(argument2, argument1);
