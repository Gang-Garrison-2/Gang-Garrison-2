{
    with(argument0) {
        instance_destroy();
    }
    with(Player) {
        killtable_delete(killTable, other.argument0);
    }
    
    ds_list_delete(global.players, ds_list_find_index(global.players, argument0));
}
