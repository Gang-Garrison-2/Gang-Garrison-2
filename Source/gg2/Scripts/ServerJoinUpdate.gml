{
    var i, player;

    writebyte(HELLO, argument0);
    
    // Write version 128 to indicate that a UUID follows
    writeshort(128, argument0);
    
    // Send version UUID (big endian)
    for(i=0; i<16; i+=1) {
        writebyte(global.protocolUuid[i], argument0);
    }
    
    writebyte(ds_list_size(global.players), argument0);
    writedouble(global.randomSeed, argument0);
    writebyte(global.currentMapArea, argument0);
    
    ServerChangeMap(global.currentMap, global.currentMapURL, global.currentMapMD5, argument0);
    
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        ServerPlayerJoin(player.name, argument0);
        ServerPlayerChangeclass(i, player.class, argument0);
        ServerPlayerChangeteam(i, player.team, argument0);
    }
    
    serializeState(FULL_UPDATE, argument0);
    
    if global.serverPassword != "" writebyte(PASSWORD_REQUEST, argument0);
}