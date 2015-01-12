// string value_to_string(value)
// Produces a string from a value for debugging purposes
// If the value is a string, adds double quotes
// If the value is a real, doesn't add anything

var value;
value = argument0;

if (is_string(value))
    return '"' + value + '"';
else
    return string(value);
