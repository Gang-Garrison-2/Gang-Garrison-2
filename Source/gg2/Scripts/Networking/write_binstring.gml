// Write a binary string (i.e. one that can contain null bytes) to a buffer.

var buffer, str, len, i;
buffer = argument0;
str = argument1;
len = string_byte_length(str);

for(i=1; i<=len; i+=1)
    write_ubyte(buffer, string_byte_at(str, i));
