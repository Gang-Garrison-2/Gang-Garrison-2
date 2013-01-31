// Creates a 16-byte random binary string
var result;
result = "";
repeat(16)
    result += chr(irandom_range(0,255));
return result;
