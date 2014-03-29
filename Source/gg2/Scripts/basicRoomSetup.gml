offloadSpawnPoints();
instance_create(0,0,TeamSelectController);

sound_stop_all();

if(global.ingameMusic) {
    AudioControlPlaySong(IngameMusic, true);
}

global.redCaps = 0;
global.blueCaps = 0;
