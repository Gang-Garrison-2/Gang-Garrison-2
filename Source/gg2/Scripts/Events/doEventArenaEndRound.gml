//changes
for(i=0; i < redMVPs; i+=1) {
    redMVPName[i] = redMVP[i].name;
    //redMVPKills[i] = redMVP[i].roundKills;
    redMVPKills[i] = redMVP[i].roundStats[KILLS];
    //redMVPHealed[i] = redMVP[i].roundHealed;
    redMVPHealed[i] = redMVP[i].roundStats[HEALING];
    //redMVPPoints[i] = redMVP[i].roundKills+redMVP[i].roundHealPoints;
    //redMVPPoints[i] = redMVP[i].roundStats[KILLS]+2*redMVP[i].roundStats[CAPS]+.5*redMVP[i].roundStats[ASSISTS]
        //+redMVP[i].roundStats[DESTRUCTION]+redMVP[i].roundStats[STABS]+floor(redMVP[i].roundStats[HEALING]/200)+
        //redMVP[i].roundStats[DEFENSES]+redMVP[i].roundStats[INVULNS]+redMVP[i].roundStats[BONUS]
    redMVPPoints[i] = redMVP[i].roundStats[POINTS];
}

for(i=0; i < blueMVPs; i+=1) {
    blueMVPName[i] = blueMVP[i].name;
    //blueMVPKills[i] = blueMVP[i].roundKills;
    blueMVPKills[i] = blueMVP[i].roundStats[KILLS];
    //blueMVPHealed[i] = blueMVP[i].roundHealed;
    blueMVPHealed[i] = blueMVP[i].roundStats[HEALING];
    //blueMVPPoints[i] = blueMVP[i].roundKills+blueMVP[i].roundHealPoints;
    //blueMVPPoints[i] = blueMVP[i].roundStats[KILLS]+2*blueMVP[i].roundStats[CAPS]+.5*blueMVP[i].roundStats[ASSISTS]
        //+blueMVP[i].roundStats[DESTRUCTION]+blueMVP[i].roundStats[STABS]+floor(blueMVP[i].roundStats[HEALING]/200)+
        //blueMVP[i].roundStats[DEFENSES]+blueMVP[i].roundStats[INVULNS]+blueMVP[i].roundStats[BONUS]
    blueMVPPoints[i] = blueMVP[i].roundStats[POINTS];
}
endCount = 1;
with Player if team != ArenaHUD.winners humiliated = 1;
with Sentry if team != ArenaHUD.winners event_user(1);

if global.myself.team == ArenaHUD.winners 
|| global.myself.team == TEAM_SPECTATOR sound = VictorySnd;
else sound = FailureSnd;
AudioControlPlaySong(sound, false);
