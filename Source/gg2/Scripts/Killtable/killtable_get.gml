//Returns the value corresponding to a player
//Arg0: Killtable
//Arg1: Player
var player_list, value_list, player_index;
player_list = ds_list_find_value(argument0, 0);
value_list = ds_list_find_value(argument0, 1);
player_index = ds_list_find_index(player_list, argument1);
return ds_list_find_value(value_list, player_index);
