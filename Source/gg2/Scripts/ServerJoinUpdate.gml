{
    var i, player;

    write_ubyte(argument0, JOIN_UPDATE);
    write_ubyte(argument0, ds_list_size(global.players));
    write_ubyte(argument0, global.currentMapArea);
    
    ServerChangeMap(global.currentMap, global.currentMapMD5, socket);
    
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        ServerPlayerJoin(player.name, argument0);
        ServerPlayerChangeclass(i, player.class, argument0);
        ServerPlayerChangeteam(i, player.team, argument0);
    }
    
    serializeState(FULL_UPDATE, argument0);
}
