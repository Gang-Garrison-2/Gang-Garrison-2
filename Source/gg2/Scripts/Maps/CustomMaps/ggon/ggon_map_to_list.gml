// real ggon_map_to_list(real map)
// Takes a ds_map which has a "length" key and string indexes up to length
// Returns a ds_list which has the values of those indexes in order
// This is to make dealing with GGON easier, as GGON doesn't understand ds_list
// This works with what decoding GGON lists, or ggon_list_to_map, produce

var map;
map = argument0;

var list, length;
list = ds_list_create();
length = real(ds_map_find_value(map, 'length'));

var i;
for (i = 0; i < length; i += 1)
    ds_list_add(list, ds_map_find_value(map, string(i)));

return list;
