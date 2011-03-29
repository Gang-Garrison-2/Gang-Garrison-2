for(i=0; i < redMVPs; i+=1) {
    redMVPName[i] = redMVP[i].name;
    redMVPKills[i] = redMVP[i].roundStats[KILLS];
    redMVPHealed[i] = redMVP[i].roundStats[HEALING];
    redMVPPoints[i] = redMVP[i].roundStats[POINTS];
}

for(i=0; i < blueMVPs; i+=1) {
    blueMVPName[i] = blueMVP[i].name;
    blueMVPKills[i] = blueMVP[i].roundStats[KILLS];
    blueMVPHealed[i] = blueMVP[i].roundStats[HEALING];
    blueMVPPoints[i] = blueMVP[i].roundStats[POINTS];
}
endCount = 1;
with Player if team != ArenaHUD.winners humiliated = 1;
with Sentry if team != ArenaHUD.winners event_user(1);

if global.myself.team == ArenaHUD.winners 
|| global.myself.team == TEAM_SPECTATOR sound = VictorySnd;
else sound = FailureSnd;
AudioControlPlaySong(sound, false);

if ArenaHUD.redWins = global.caplimit { global.winners = TEAM_RED; }
if ArenaHUD.blueWins = global.caplimit { global.winners = TEAM_BLUE; }
