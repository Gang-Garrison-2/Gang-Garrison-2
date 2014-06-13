with(ArenaHUD) {
    roundStart = 300;
    endCount = 0;
    cpUnlock = 1800;
    winners = TEAM_SPECTATOR;
}

ArenaControlPoint.team = -1;
ArenaControlPoint.locked = 1;
with Player humiliated = 0;
with Sentry instance_destroy();
with SentryGibs instance_destroy();
    
if(global.music == MUSIC_BOTH || global.music == MUSIC_INGAME_ONLY) 
{
    global.IngameMusic=faudio_new_generator(global.IngameMusicS);
    
    if(global.IngameMusic != -1)
    {
        faudio_volume_generator(global.IngameMusic, 0.8);
        AudioControlPlaySong(global.IngameMusic, true);
    }
}
