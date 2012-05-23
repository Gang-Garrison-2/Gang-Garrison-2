// Prints the given argument to the console, while also deleting old stuff.
// Note: The name is from a plugin convention
// argument0 == what should be printed.

var input, tmpstring;
input = argument0

while string_length(input) > 84// Basic line breaking, prevents text from leaving the console.
{
    tmpstring = string_copy(input, 0, 83);
    string_
    ds_list_add(global.consoleLog, tmpstring);
    input = string_copy(input, string_length(tmpstring), string_length(input));
}

ds_list_add(global.consoleLog, input);

while ds_list_size(global.consoleLog) > 36
{
    ds_list_delete(global.consoleLog, 0)
}
