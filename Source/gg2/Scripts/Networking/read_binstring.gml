// Function for reading a binary string from a buffer (i.e. a string that can contain null bytes)

var buffer, len, result;
buffer = argument0;
len = argument1;
result = "";
repeat(len)
    result += ansi_char(read_ubyte(buffer));
return result;
