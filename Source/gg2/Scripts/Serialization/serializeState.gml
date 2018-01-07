{
    // Writes gamestate to the given buffer.
    // The first argument determines how detailled this information
    // is supposed to be:
    // INPUTSTATE gathers the keypresses and aim direction of every player
    // QUICK_UPDATE additionally gathers the player health, position and movement values
    // FULL_UPDATE gathers all relevant information
    // argument0: Type of update
    // argument1: Buffer to write the state data to

    var i, player;
        
    global.updateType=argument0;
    
    write_ubyte(argument1, argument0);
    
    if(argument0 == FULL_UPDATE) {
        write_ushort(argument1, global.tdmInvulnerabilityTicks);
    }
    
    write_ubyte(argument1, ds_list_size(global.players));
    
    global.serializeBuffer = argument1;

    if argument0 != CAPS_UPDATE {
        for(i=0; i<ds_list_size(global.players); i+=1) {
            player = ds_list_find_value(global.players, i);
            with(player) {
                event_user(12);
            }
        }
        
        with(MovingPlatform)
            event_user(10);
    }

    if(argument0 == FULL_UPDATE) {
        serialize(IntelligenceRed);
        serialize(IntelligenceBlue);
        
        write_ubyte(argument1, global.caplimit);
        write_ubyte(argument1, global.redCaps);
        write_ubyte(argument1, global.blueCaps);
        write_ubyte(argument1, global.Server_RespawntimeSec);
        with (HUD)
            event_user(12);
        
        // Write classlimits to joining client
        for (a = 0; a < 10; a += 1)
            write_ubyte(argument1, global.classlimits[a]);
    }
    
    if(argument0 == CAPS_UPDATE) {
              
        write_ubyte(argument1, global.redCaps);
        write_ubyte(argument1, global.blueCaps);
        write_ubyte(argument1, global.Server_RespawntimeSec);
        with (HUD)
            event_user(12);
    }
}
