//Returns the number of values >3
//Arg0: Player
var dominationKills, count, key;
dominationKills = argument0.dominationKills;
count = 0;
for (key = ds_map_find_first(dominationKills); key; key = ds_map_find_next(dominationKills, key))
{
    if (ds_map_find_value(dominationKills, key) > 3)
        count += 1;
}
return count;
