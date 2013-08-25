// Splits CSV into items
// argument0 - string comma-separated values
// argument1 - delimeter
// return value - ds_list containing strings of values

var list, text, delimeter;
text = argument0;
delimeter = argument1;
list = ds_list_create();

while (string_pos(delimeter, text) != 0)
{
    ds_list_add(list, string_copy(text, 1, string_pos(delimeter,text) - string_length(delimeter)));
    text = string_copy(text, string_pos(delimeter, text) + string_length(delimeter), string_length(text) - string_pos(delimeter, text));
}
if (string_length(text) > 0)
{
    ds_list_add(list, text);
}

return list;
