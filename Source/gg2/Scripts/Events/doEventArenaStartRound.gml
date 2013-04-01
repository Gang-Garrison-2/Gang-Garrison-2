ArenaHUD.gameStarted = 1;
with (Player)
{
    if (team != TEAM_SPECTATOR)
    {
        if (object != -1)
            with (object)
                instance_destroy();
        object = -1;
        alarm[5] = 1;
    }
    alarm[0]=2;

    roundStats[KILLS] = 0;
    roundStats[DEATHS] = 0;
    roundStats[ASSISTS] = 0;
    roundStats[DESTRUCTION] = 0;
    roundStats[STABS] = 0;
    roundStats[HEALING] = 0;
    roundStats[INVULNS] = 0;
    roundStats[BONUS] = 0;
    roundStats[CAPS] = 0;
    roundStats[DEFENSES] = 0;
    roundStats[DOMINATIONS] = 0;
    roundStats[REVENGE] = 0;
    roundStats[POINTS] = 0;
}

with (Sentry)
    instance_destroy();
with (SentryGibs)
    instance_destroy();
with (Rocket)
    instance_destroy();
with (Shot)
    instance_destroy();
with (BurningProjectile)
    instance_destroy();
with (Needle)
    instance_destroy();

if instance_exists(TeamSelectController) with TeamSelectController instance_destroy();
if instance_exists(ClassSelectController) with ClassSelectController instance_destroy();
