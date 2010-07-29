var uuidString, currentNibble, posValueString, numericByte;

// Parses the PROTOCOL_UUID and stores the bytes in the array global.protocolUuid
// in big-endian order.
// Remove all dashes
uuidString = string_lower(string_replace_all(PROTOCOL_UUID,"-",""));
if(string_length(uuidString)!=32) {
    show_error("Invalid UUID format for global constant PROTOCOL_UUID", true);
}

posValueString = "0123456789abcdef";
for(i=0; i<16; i+=1) {
    currentNibble = string_char_at(uuidString,i*2+1);
    if(string_pos(currentNibble, posValueString)==0) {
        show_error("Invalid UUID format for global constant PROTOCOL_UUID", true);
    }
    numericByte = (string_pos(currentNibble, posValueString)-1)*16;
    
    currentNibble = string_char_at(uuidString,i*2+2);
    if(string_pos(currentNibble, posValueString)==0) {
        show_error("Invalid UUID format for global constant PROTOCOL_UUID", true);
    }
    numericByte += string_pos(currentNibble, posValueString)-1;
    
    global.protocolUuid[i]=numericByte;
}