// Splits CSV into items
// argument0 - string comma-separated values
// return value - ds_list containing strings of values

var list, text;
text = argument0;
list = ds_list_create();

while (string_pos(",", text) != 0)
{
    ds_list_add(list, string_copy(text,0,string_pos(",",text)-1));
    text = string_copy(text,string_pos(",",text)+1,string_length(text)-string_pos(",",text));
}
if (string_length(text) > 0)
{
    ds_list_add(list, text);
}

return list;
