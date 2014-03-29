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
    
    writebyte(argument0, argument1);
    writebyte(ds_list_size(global.players), argument1);
    
    global.serializeBuffer = argument1;
    
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        with(player) {
            event_user(12);
        }
    }
    
    if(argument0 == FULL_UPDATE) {
        serialize(IntelligenceRed);
        serialize(IntelligenceBlue);
    
        writeushort(global.redCaps, argument1);
        writeushort(global.blueCaps, argument1);
    }
}