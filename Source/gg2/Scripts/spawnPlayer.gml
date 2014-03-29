{
    // Argument 0: Player Instance
    // Argument 1: Spawnpoint ID
    var spawnX, spawnY, playerObject, character, sprite;
    
    if(argument0.team == TEAM_RED) {
        spawnX = ds_list_find_value(global.spawnPointsRedX, argument1);
        spawnY = ds_list_find_value(global.spawnPointsRedY, argument1);
    } else {
        spawnX = ds_list_find_value(global.spawnPointsBlueX, argument1);
        spawnY = ds_list_find_value(global.spawnPointsBlueY, argument1);
    }
    character = getCharacterObject(argument0.team, argument0.class);
    if(character == -1) {
        show_message("Spawning a player did not succeed because his class and/or team were invalid.");
        exit;
    }

    if(argument0.object != -1) {
        with(argument0.object) {
            instance_destroy();
        }
        argument0.object=-1;
    }
    argument0.object = instance_create(spawnX,spawnY,character);
    argument0.object.player = argument0;
    argument0.object.team = argument0.team;
    with(argument0.object) {
        event_user(0);
    }
    playsound(spawnX, spawnY, RespawnSnd);
}