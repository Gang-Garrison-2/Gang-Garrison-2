{
    var i, player;

    writebyte(HELLO, argument0);
    writeshort(PROTOCOL_VERSION, argument0);
    writebyte(ds_list_size(global.players), argument0);
    writedouble(global.randomSeed, argument0);
    
    ServerChangeMap(global.currentMap, global.currentMapURL, global.currentMapMD5, argument0);
    
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        ServerPlayerJoin(player.name, argument0);
        ServerPlayerChangeclass(i, player.class, argument0);
        ServerPlayerChangeteam(i, player.team, argument0);
    }
    
    serializeState(FULL_UPDATE, argument0);
}