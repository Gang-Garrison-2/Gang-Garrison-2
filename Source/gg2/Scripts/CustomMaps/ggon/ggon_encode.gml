// string ggon_encode(real/string value)
// Encodes a ds_map or string to a GGON (Gang Garrison Object Notation) text
// Encoding is recursive, real values in the maptreated as ds_map handles
// Returns the encoded text

var value;
value = argument0;

var out;

// string value
if (is_string(value))
{
    // Check if alphanumeric
    var alphanumeric, i, char;
    // We don't set alphanumeric to true ahead of time because of empty strings
    alphanumeric = false;
    for (i = 1; i <= string_length(value); i += 1)
    {
        char = string_char_at(value, i);
        if (('a' <= char and char <= 'z') or ('A' <= char and char <= 'Z') or ('0' <= char and char <= '9') or char == '_' or char == '.' or char == '+' or char == '-')
        {
            alphanumeric = true;
        }
        else
        {
            alphanumeric = false;
            break;
        }
    }
    
    // As no quoting is necessary, just output verbatim
    if (alphanumeric)
    {
        out = value;
        return out;
    }
    
    out = "'";
    for (i = 1; i <= string_length(value); i += 1)
    {
        char = string_char_at(value, i);
        // ' and \ are escaped as \' and ''
        if (char == "'" or char == "\")
            out += '\' + char;
        // newlines, carriage returns, tabs and null bytes are escaped specially
        else if (char == chr(10))
            out += '\n';
        else if (char == chr(13))
            out += '\r';
        else if (char == chr(9))
            out += '\t';
        else if (char == chr(0))
            out += '\0';
        // Otherwise we can just output verbatim
        else
            out += char;
    }
    out += "'";
    
    return out;
// not string, therefore real, therefore ds_map representing map value
} else {
    out = "{";
    
    var key, first;
    first = true;
    for (key = ds_map_find_first(value); is_string(key); key = ds_map_find_next(value, key))
    {
        if (!first)
            out += ',';
        else
            first = false;
        out += ggon_encode(key) + ':' + ggon_encode(ds_map_find_value(value, key));
    }
    
    out += "}";
    
    return out;
}
