//Adds 1 to the count for the specified player, in the specified kill table.
//If player is not found, add them to the table.
//Arg0: Killtable
//Arg1: Player
var player_list, value_list, player_index, value_value;
player_list = ds_list_find_value(argument0, 0);
value_list = ds_list_find_value(argument0, 1);
player_index = ds_list_find_index(player_list, argument1);
value_value = ds_list_find_value(value_list, player_index);

if (ds_list_find_index(player_list,argument1) != -1) {
    ds_list_replace(value_list, player_index, value_value + 1);
}
else {
    killtable_add(argument0, argument1);
    killtable_increase(argument0, argument1);
}
