var key, msg, o_key_pad, i_key_pad, i, blocksize, byte, keylen;
key = argument0;
msg = argument1;
blocksize = 64;

if(string_byte_length(key) > blocksize)
    key = md5_bin(key);
repeat(blocksize-string_byte_length(key))
    key += ansi_char(0);
o_key_pad = "";
i_key_pad = "";
for(i=1; i<=blocksize; i+=1)
{
    byte = string_byte_at(key, i);
    o_key_pad += ansi_char(byte^$5c);
    i_key_pad += ansi_char(byte^$36);
}

return md5_bin(o_key_pad + md5_bin(i_key_pad+msg));
