var key, value;
key = argument1;
value = argument2;

if(string_length(key) > 255)
    show_error("Key too long: "+key, true);
    
if(string_length(value) > 65535)
    value = string_copy(value, 0, 65535);
    
write_ubyte(argument0, string_length(key));
write_string(argument0, key);
write_ushort(argument0, string_length(value));
write_string(argument0, value);
