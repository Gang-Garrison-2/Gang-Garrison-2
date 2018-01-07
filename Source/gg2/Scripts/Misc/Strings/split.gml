// real split(string text, delimeter delimeter[, real limit])
// Splits string into items
// text - string comma-separated values
// delimeter - delimeter to split by
// limit (optional) - if specified, maximum times to split text
// When limited, the remaining text will be left as the last item.
// E.g. splitting "1,2,3,4,5" with delimeter "," and limit 2 yields this list:
// "1", "2", "3,4,5"
// return value - ds_list containing strings of values

var text, delimeter, limit;
text = argument0;
delimeter = argument1;
limit = argument2;

var list, count;
list = ds_list_create();
count = 0;

while (string_pos(delimeter, text) != 0)
{
    ds_list_add(list, string_copy(text, 1, string_pos(delimeter,text) - 1));
    text = string_copy(text, string_pos(delimeter, text) + string_length(delimeter), string_length(text) - string_pos(delimeter, text));

    count += 1;
    if (limit and count == limit)
        break;
}
ds_list_add(list, text);

return list;
