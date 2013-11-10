// Takes a lowercase hexadecimal string and returns its integer value
// real httpParseHex(string hexString)

// Return value is the whole number value (or -1 if invalid)
// Only works for whole numbers (non-fractional numbers >= 0) and lowercase hex

var hexString;
hexString = argument0;

var result, hexValues;
result = 0;
hexValues = "0123456789abcdef";

var i;
for (i = 1; i <= string_length(hexString); i += 1) {
    result *= 16;
    var digit;
    digit = string_pos(string_char_at(hexString, i), hexValues) - 1;
    if (digit == -1)
        return -1;
    result += digit;
}

return result;
