// Reads the first value in a list, then moves it to the back of the list
if(ds_list_size(argument0) < 0)
    return NAN;

var n;
n = ds_list_find_value(argument0, 0);
ds_list_delete(argument0, 0);
ds_list_add(argument0, n);
return n;

