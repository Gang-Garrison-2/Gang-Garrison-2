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

    if argument0 != CAPS_UPDATE {
       
        for(i=0; i<ds_list_size(global.players); i+=1) {
            player = ds_list_find_value(global.players, i);
            with(player) {
                event_user(12);
            }
        }
    }

    if(argument0 == FULL_UPDATE) {
        serialize(IntelligenceRed);
        serialize(IntelligenceBlue);
        
        writebyte(global.caplimit, argument1);
        writebyte(global.redCaps, argument1);
        writebyte(global.blueCaps, argument1);
        writebyte(global.Server_RespawntimeSec, argument1);
        if instance_exists(ControlPointHUD) {
            with ControlPointHUD event_user(12);
        }
        else if instance_exists(ScorePanel) {
            with ScorePanel event_user(12);
        }
        else if instance_exists(GeneratorHUD) {
            with GeneratorHUD event_user(12);
        }
        else if instance_exists(ArenaHUD) {
            with ArenaHUD event_user(12);
        }
    }
    
    if(argument0 == CAPS_UPDATE) {
              
        writebyte(global.redCaps, argument1);
        writebyte(global.blueCaps, argument1);
        writebyte(global.Server_RespawntimeSec, argument1);
        if instance_exists(ControlPointHUD) {
            with ControlPointHUD event_user(12);
        }
        else if instance_exists(ScorePanel) {
            with ScorePanel event_user(12);
        }
        else if instance_exists(GeneratorHUD) {
            with GeneratorHUD event_user(12);
        }
        else if instance_exists(ArenaHUD) {
            with ArenaHUD event_user(12);
        }
    }
}
