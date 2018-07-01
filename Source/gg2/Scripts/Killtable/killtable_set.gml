//Sets the player's corresponding value
//Arg0: Killtable
//Arg1: Player
//Arg2: Value
player_list = ds_list_find_value(argument0, 0);
value_list = ds_list_find_value(argument0, 1);
player_index = ds_list_find_index(player_list, argument1);
ds_list_replace(value_list, player_index, argument2);
