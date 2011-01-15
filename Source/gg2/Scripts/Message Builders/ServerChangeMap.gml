// argument0 - mapname
// argument1 - mapurl
// argument2 - mapmd5
// argument3 - buffer

write_ubyte(argument3, CHANGE_MAP);
write_ubyte(argument3, string_length(argument0));
write_string(argument3, argument0);
write_ubyte(argument3, string_length(argument1));
write_string(argument3, argument1);
write_ubyte(argument3, string_length(argument2));
write_string(argument3, argument2);
