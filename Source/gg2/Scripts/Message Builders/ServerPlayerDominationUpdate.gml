var player, length, player_list, value_list;
write_ubyte(argument1, PLAYER_DOMINATION_UPDATE);
write_ubyte(argument1, argument0);
player = ds_list_find_value(global.players, argument0);
length = killtable_length(player.killTable);
player_list = ds_list_find_value(player.killTable, 0);
value_list = ds_list_find_value(player.killTable, 1);
write_ubyte(argument1, length);
for (i = 0; i < length; i += 1) {
    write_ubyte(argument1, ds_list_find_index(global.players,ds_list_find_value(player_list, i)));
    write_ubyte(argument1, ds_list_find_value(value_list, i));
}

