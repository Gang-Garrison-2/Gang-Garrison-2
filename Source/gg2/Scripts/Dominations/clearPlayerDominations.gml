//Removes a player from all kill tables (on leave/team change)
//Arg 0 : Player to be cleared
var player;
for (i = 0; i < ds_list_size(global.players); i += 1) {
    player = ds_list_find_value(global.players, i);
    domination_kills_delete(player.dominationKills, argument0);
}
domination_kills_clear(argument0.dominationKills);
