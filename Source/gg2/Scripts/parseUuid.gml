var uuidString, currentNibble, posValueString, numericByte;

// Parses the given UUID and appends it to the provided buffer in big-endian order.
// argument0: UUID hex string
// argument1: Buffer

uuidString = string_lower(string_replace_all(argument0,"-",""));
if(string_length(uuidString)!=32)
    show_error("Invalid UUID: "+argument0, true);

posValueString = "0123456789abcdef";
for(i=0; i<16; i+=1)
{
    currentNibble = string_char_at(uuidString,i*2+1);
    if(string_pos(currentNibble, posValueString)==0)
        show_error("Invalid UUID: "+argument0, true);
    numericByte = (string_pos(currentNibble, posValueString)-1)*16;
    
    currentNibble = string_char_at(uuidString,i*2+2);
    if(string_pos(currentNibble, posValueString)==0)
        show_error("Invalid UUID: "+argument0, true);
    numericByte += string_pos(currentNibble, posValueString)-1;
    
    write_ubyte(argument1, numericByte);
}
