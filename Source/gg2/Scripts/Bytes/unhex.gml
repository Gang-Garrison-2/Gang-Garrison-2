var i, strlen, result, byte, hextable;
strlen = string_length(argument0);
if((strlen mod 2) != 0)
{
    show_error("Hex string has invalid length: "+argument0, false);
    return "";
}

argument0 = string_lower(argument0);

result = "";
for(i=1; i<=strlen; i+=2)
{
    byte = (string_pos(string_char_at(argument0, i), "0123456789abcdef")-1)<<4;
    byte += (string_pos(string_char_at(argument0, i+1), "0123456789abcdef")-1);
    result += chr(byte);
}

return result;
