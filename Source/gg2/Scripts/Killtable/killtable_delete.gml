//Removes a player and its corresponding value
//Arg0: Killtable
//Arg1: Player
var player_list, value_list, index;
player_list = ds_list_find_value(argument0, 0);
value_list = ds_list_find_value(argument0, 1);
index = ds_list_find_index(player_list, argument1);
ds_list_delete(player_list, index);
ds_list_delete(value_list, index);
