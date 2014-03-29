if(variable_global_exists("spawnPointsRedX")) {
    ds_list_clear(global.spawnPointsRedX);
} else {
    global.spawnPointsRedX = ds_list_create();
}

if(variable_global_exists("spawnPointsRedY")) {
    ds_list_clear(global.spawnPointsRedY);
} else {
    global.spawnPointsRedY = ds_list_create();
}

if(variable_global_exists("spawnPointsBlueX")) {
    ds_list_clear(global.spawnPointsBlueX);
} else {
    global.spawnPointsBlueX = ds_list_create();
}

if(variable_global_exists("spawnPointsBlueY")) {
    ds_list_clear(global.spawnPointsBlueY);
} else {
    global.spawnPointsBlueY = ds_list_create();
}

with(SpawnPointRed) {
    ds_list_add(global.spawnPointsRedX,x);
    ds_list_add(global.spawnPointsRedY,y);
}

with(SpawnPointBlue) {
    ds_list_add(global.spawnPointsBlueX,x);
    ds_list_add(global.spawnPointsBlueY,y);
}
