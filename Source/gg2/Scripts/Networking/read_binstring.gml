// Function for reading a binary string from a buffer (i.e. a string that can contain null bytes)
// Slow, and probably doesn't work in GM8.1 and onwards, but there you go.

var buffer, len, result;
buffer = argument0;
len = argument1;
result = "";
repeat(len)
    result += chr(read_ubyte(buffer));
return result;
