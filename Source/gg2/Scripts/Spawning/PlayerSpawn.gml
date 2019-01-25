// Called in Player context
if(global.isHost and !global.mapchanging and team != TEAM_SPECTATOR and object == -1) {
    var group, spawnpointID, numSpawnPoints;
    group = selectSpawnGroup(team);
    if (group==-1) {
        show_message("This map does not contain valid spawn points");
        game_end();
    }
    if(team == TEAM_RED) {
        numSpawnPoints = ds_list_size(global.spawnPointsRed[0,group]);
    } else {
        numSpawnPoints = ds_list_size(global.spawnPointsBlue[0,group]);
    }
    spawnpointID = floor(random(numSpawnPoints));
    sendEventSpawn(id, spawnpointID, group);
    doEventSpawn(id, spawnpointID, group);
}
