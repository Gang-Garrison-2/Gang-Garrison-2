// argument0 - mapname
// argument1 - mapurl
// argument2 - mapmd5
// argument3 - buffer

{
    writebyte(CHANGE_MAP, argument3);
    writebyte(string_length(argument0), argument3);
    writechars(argument0, argument3);
    writebyte(string_length(argument1), argument3);
    writechars(argument1, argument3);
    writebyte(string_length(argument2), argument3);
    writechars(argument2, argument3);
}