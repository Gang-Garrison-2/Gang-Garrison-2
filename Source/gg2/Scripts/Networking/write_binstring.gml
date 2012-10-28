// Write a binary string (i.e. one that can contain null bytes) to a buffer.
// Slow, and probably doesn't work in GM8.1 and onwards, but there you go.

var buffer, str, len, i;
buffer = argument0;
str = argument1;
len = string_length(str);

for(i=1; i<=len; i+=1)
    write_ubyte(buffer, ord(string_char_at(str, i)));
