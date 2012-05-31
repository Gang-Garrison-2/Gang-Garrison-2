var message;
message = string_copy(argument0, 0, 255);
write_ubyte(argument1, MESSAGE_STRING);
write_ubyte(argument1, string_length(message));
write_string(argument1, message);
