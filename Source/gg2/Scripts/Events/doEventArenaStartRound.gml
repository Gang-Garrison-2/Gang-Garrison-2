with(ArenaHUD)
{
    winners = TEAM_SPECTATOR;
    endCount = 0;
    roundStart = 0;
    cpUnlock = 1800;
    state = ARENA_STATE_ROUND_PROPER;
}

destroyGameplayObjects();
resetRoundStats();
respawnEveryone();

if instance_exists(TeamSelectController) with TeamSelectController instance_destroy();
if instance_exists(ClassSelectController) with ClassSelectController instance_destroy();
