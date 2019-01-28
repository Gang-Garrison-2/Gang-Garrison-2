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

if((global.music == MUSIC_BOTH or global.music == MUSIC_INGAME_ONLY)
    and (AudioControl.currentSong != global.IngameMusic)) {
    AudioControlPlaySong(global.IngameMusic, true);
}
