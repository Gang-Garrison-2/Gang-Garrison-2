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
    
if(global.ingameMusic and (AudioControl.currentSong != global.IngameMusic)) {
    AudioControlPlaySong(global.IngameMusic, true);
}
