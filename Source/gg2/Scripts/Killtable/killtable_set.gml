//Sets the player's corresponding value
//Arg0: Killtable
//Arg1: Player
//Arg2: Value
if (ds_map_exists(argument0, argument1))
    ds_map_replace(argument0, argument1, argument2);
else
    ds_map_add(argument0, argument1, argument2);
