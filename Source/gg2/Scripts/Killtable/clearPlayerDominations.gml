//Removes a player from all kill tables (on leave/team change)
//Arg 0 : Player to be cleared
for (i = 0; i < ds_list_size(global.players); i += 1) {
    player = ds_list_find_value(global.players, i);
    killtable_delete(player.killTable, argument0);
}
killtable_clear(argument0.killTable);
