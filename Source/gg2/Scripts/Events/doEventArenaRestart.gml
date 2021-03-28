with(ArenaHUD) {
    winners = TEAM_SPECTATOR;
    endCount = 0;
    roundStart = 300;
    cpUnlock = 1800;
    state = ARENA_STATE_ROUND_SETUP;
}

ArenaControlPoint.team = -1;
ArenaControlPoint.locked = 1;
with Player humiliated = 0;

destroyGameplayObjects();
respawnEveryone();

faudio_kill_all_generators(); //kill all generators
global.IngameMusic = faudio_new_generator(global.IngameMusicS);
if(global.music == MUSIC_BOTH || global.music == MUSIC_INGAME_ONLY)
{

    if(global.IngameMusic != -1)
    {
        faudio_volume_generator(global.IngameMusic, 0.8);
        AudioControlPlaySong(global.IngameMusic, true);
    }
}
