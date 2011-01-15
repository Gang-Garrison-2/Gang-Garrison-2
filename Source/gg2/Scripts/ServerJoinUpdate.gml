{
    var i, player;

    write_ubyte(argument0, HELLO);
    
    // Write version 128 to indicate that a UUID follows
    write_short(argument0, 128);
    
    // Send version UUID (big endian)
    for(i=0; i<16; i+=1) {
        write_ubyte(argument0, global.protocolUuid[i]);
    }
    
    write_ubyte(argument0, ds_list_size(global.players));
    write_double(argument0, global.randomSeed);
    write_ubyte(argument0, global.currentMapArea);
    
    ServerChangeMap(global.currentMap, global.currentMapURL, global.currentMapMD5, argument0);
    
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        ServerPlayerJoin(player.name, argument0);
        ServerPlayerChangeclass(i, player.class, argument0);
        ServerPlayerChangeteam(i, player.team, argument0);
    }
    
    serializeState(FULL_UPDATE, argument0);
    
    if global.serverPassword != "" write_ubyte(argument0, PASSWORD_REQUEST);
}
