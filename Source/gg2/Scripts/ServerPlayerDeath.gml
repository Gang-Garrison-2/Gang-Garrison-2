{
    writebyte(PLAYER_DEATH, argument1);
    writebyte(ds_list_find_index(global.players, argument0), argument1);
    
    if(argument0.recentlyKilledBy == 0 or (not instance_exists(argument0.recentlyKilledBy))) {
        writebyte(255, argument1);
    } else {
        writebyte(ds_list_find_index(global.players, argument0.recentlyKilledBy), argument1);
    }
    writebyte(argument0.recentlyKilledWith, argument1);
}