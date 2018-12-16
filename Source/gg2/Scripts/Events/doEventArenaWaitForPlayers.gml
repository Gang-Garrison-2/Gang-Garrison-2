with(ArenaHUD)
{
    winners = TEAM_SPECTATOR;
    endCount = 0;
    roundStart = 0;
    cpUnlock = 1800;
    state = ARENA_STATE_WAITING;
}

ArenaControlPoint.team = -1;
ArenaControlPoint.locked = 1;
with Player humiliated = 0;

destroyGameplayObjects();
respawnEveryone();
