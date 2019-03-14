//Returns the value corresponding to a player
//Arg0: Killtable
//Arg1: Player
if (ds_map_exists(argument0, argument1))
    return ds_map_find_value(argument0, argument1);
else
    return 0;
