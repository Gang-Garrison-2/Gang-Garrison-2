var i;
if(variable_global_exists("spawnPointsRed")) {
    for (i=0;i<=4; i+=1){
        ds_list_clear(global.spawnPointsRed[0,i]);
        ds_list_clear(global.spawnPointsRed[1,i]);
    }
} else {
    globalvar spawnPointsRed;
    for (i=0;i<=4;i+=1){
        global.spawnPointsRed[0,i] = ds_list_create();
        global.spawnPointsRed[1,i] = ds_list_create();
    }
}

if(variable_global_exists("spawnPointsBlue")) {
    for (i=0;i<=4;i+=1){
        ds_list_clear(global.spawnPointsBlue[0,i]);
        ds_list_clear(global.spawnPointsBlue[1,i]);
    }
} else {
    globalvar spawnPointsBlue;
    for (i=0;i<=4;i+=1){
        global.spawnPointsBlue[0,i] = ds_list_create();
        global.spawnPointsBlue[1,i] = ds_list_create();
    }
}
with (SpawnPointRed) {
    ds_list_add(global.spawnPointsRed[0,group],x);
    ds_list_add(global.spawnPointsRed[1,group],y);
}
with (SpawnPointBlue) {
    ds_list_add(global.spawnPointsBlue[0,group],x);
    ds_list_add(global.spawnPointsBlue[1,group],y);
}
