// Probably does not work for GM 8.1 and up due to changed string handling.
// Replace with extension function if needed.

var key, msg, o_key_pad, i_key_pad, i, blocksize, byte, keylen;
key = argument0;
msg = argument1;
blocksize = 64;

if(string_length(key) > blocksize)
    key = md5_bin(key);
repeat(blocksize-string_length(key))
    key += chr(0);
o_key_pad = "";
i_key_pad = "";
for(i=1; i<=blocksize; i+=1)
{
    byte = ord(string_char_at(key, i));
    o_key_pad += chr(byte^$5c);
    i_key_pad += chr(byte^$36);
}

return md5_bin(o_key_pad + md5_bin(i_key_pad+msg));
