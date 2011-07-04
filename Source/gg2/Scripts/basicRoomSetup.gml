room_caption = global.currentMap;

global.startedGame = true;

global.totalMapAreas = 1+instance_number(NextAreaO);

if global.totalMapAreas > 1 {
    global.area[1] = 0;
    
    for(i=2;i<=global.totalMapAreas;i+=1) {
        global.area[i] = instance_find(NextAreaO,i-2).y;
    }

    if global.currentMapArea == 1 {
        with all if y > global.area[2] instance_destroy();
    }
    else if global.currentMapArea < global.totalMapAreas {
        with all if (y > global.area[global.currentMapArea+1] || y < global.area[global.currentMapArea]) && y > 0 instance_destroy();
    }
    else if global.currentMapArea == global.totalMapAreas {
        with all if y < global.area[global.currentMapArea] && y > 0 instance_destroy();
    }
}

offloadSpawnPoints();
with(Player) {
    canSpawn = 1;
    humiliated = 0;
}

if instance_exists(IntelligenceBaseBlue) || instance_exists(IntelligenceBaseRed) || instance_exists(IntelligenceRed) || instance_exists(IntelligenceBlue) instance_create(0,0,ScorePanel);
else if instance_exists(GeneratorBlue) || instance_exists(GeneratorRed) {
    instance_create(0,0,GeneratorHUD);
} else if instance_exists(ArenaControlPoint) {
    instance_create(0,0,ArenaHUD);
    if ArenaHUD.roundStart == 0 with Player canSpawn = 0;
}else if instance_exists(KothControlPoint) {
    instance_create(0,0,KothHUD);
}else if instance_exists(KothRedControlPoint) && instance_exists(KothBlueControlPoint) {
    instance_create(0,0,DKothHUD);
} else if instance_exists(ControlPoint) {
    with ControlPoint event_user(0);
    instance_create(0,0,ControlPointHUD);
}

instance_create(0,0,TeamSelectController);
if !instance_exists(KillLog) instance_create(0,0,KillLog);

sound_stop_all();

if(global.ingameMusic) {
    AudioControlPlaySong(global.IngameMusic, true);
}
instance_create(map_width()/2,map_height()/2,Spectator);

global.redCaps = 0;
global.blueCaps = 0;
global.winners = -1;
