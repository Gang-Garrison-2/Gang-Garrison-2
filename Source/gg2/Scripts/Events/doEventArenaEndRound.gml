var win;
win = argument0;

for(i=0; i < mvps[TEAM_RED]; i+=1) {
    mvpName[TEAM_RED,i] = redMVP[i].name;
    mvpKills[TEAM_RED,i] = redMVP[i].roundStats[KILLS];
    mvpHealed[TEAM_RED,i] = redMVP[i].roundStats[HEALING];
    mvpPoints[TEAM_RED,i] = redMVP[i].roundStats[POINTS];
}

for(i=0; i < mvps[TEAM_BLUE]; i+=1) {
    mvpName[TEAM_BLUE,i] = blueMVP[i].name;
    mvpKills[TEAM_BLUE,i] = blueMVP[i].roundStats[KILLS];
    mvpHealed[TEAM_BLUE,i] = blueMVP[i].roundStats[HEALING];
    mvpPoints[TEAM_BLUE,i] = blueMVP[i].roundStats[POINTS];
}

with(ArenaHUD)
{
    winners = win;
    endCount = 300;
    roundStart = 0;
    state = ARENA_STATE_ROUND_END;
}

with Player if team != win humiliated = 1;
with Sentry if team != win event_user(1);

if (global.myself.team == win or global.myself.team == TEAM_SPECTATOR)
{
    sound = global.VictoryMusic;
}
else
{
    sound = global.FailureMusic;
}
AudioControlPlaySong(sound, false);
