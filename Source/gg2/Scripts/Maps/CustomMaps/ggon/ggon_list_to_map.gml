// real ggon_list_to_map(real list)
// Takes a ds_list
// Returns a ds_map which has a "length" key and a string key for each index
// This is to make dealing with GGON easier, as GGON doesn't understand ds_list
// The map produced has the same format as a decoded a GGON list

var list;
list = argument0;

var map;
map = ds_map_create();

ds_map_add(map, "length", string(ds_list_size(list)));

var i;
for (i = 0; i < ds_list_size(list); i += 1)
{
    ds_map_add(map, string(i), ds_list_find_value(list, i));
}

return map;
