//Returns the number of values >3
//Arg0: Player
var killtable, count, key;
killtable = argument0.killTable;
count = 0;
for (key = ds_map_find_first(killtable); key; key = ds_map_find_next(killtable, key))
{
    if (ds_map_find_value(killtable, key) > 3)
        count += 1;
}
return count;
