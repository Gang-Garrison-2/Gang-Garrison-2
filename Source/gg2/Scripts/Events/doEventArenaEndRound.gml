for(i=0; i < redMVPs; i+=1) {
    redMVPName[i] = redMVP[i].name;
    redMVPKills[i] = redMVP[i].roundKills;
    redMVPHealed[i] = redMVP[i].roundHealed;
    redMVPPoints[i] = redMVP[i].roundKills+redMVP[i].roundHealPoints;
}

for(i=0; i < blueMVPs; i+=1) {
    blueMVPName[i] = blueMVP[i].name;
    blueMVPKills[i] = blueMVP[i].roundKills;
    blueMVPHealed[i] = blueMVP[i].roundHealed;
    blueMVPPoints[i] = blueMVP[i].roundKills+blueMVP[i].roundHealPoints;
}
endCount = 1;
with Player if team != ArenaHUD.winners humiliated = 1;
with Sentry if team != ArenaHUD.winners event_user(1);

if global.myself.team == ArenaHUD.winners 
|| global.myself.team == TEAM_SPECTATOR sound = VictorySnd;
else sound = FailureSnd;
AudioControlPlaySong(sound, false);
