//Returns the number of values >3
//Arg0: Player
var killtable, value_list, count;
killtable = argument0.killTable;
value_list = ds_list_find_value(killtable, 1);
count = 0;
for (i = 0; i < ds_list_size(value_list); i += 1)
    if (ds_list_find_value(value_list, i) > 3) count += 1;
return count;
