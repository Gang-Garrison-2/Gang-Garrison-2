if winners == TEAM_RED {
    consecutiveRedWins += 1;
    consecutiveBlueWins = 0;
}
else {
    consecutiveBlueWins += 1;
    consecutiveRedWins = 0;
}
redteam = ds_priority_create();
blueteam = ds_priority_create();  

for(i=0; i<ds_list_size(global.players); i+=1) {
    player = ds_list_find_value(global.players, i);
    if(player.team == TEAM_RED) {
        //ds_priority_add(redteam, player, player.roundKills+player.roundHealPoints+player.roundStabKills);
        //ds_priority_add(redteam, player, player.stats[KILLS]+2*player.stats[CAPS]+.5*player.stats[ASSISTS]+player.stats[DESTRUCTION]+player.stats[STABS]+floor(player.stats[HEALING]/200)+player.stats[DEFENSES]+player.stats[INVULNS]+player.stats[BONUS]);
        ds_priority_add(redteam, player, player.roundStats[POINTS]);
    } else if (player.team == TEAM_BLUE) {
        //ds_priority_add(blueteam, player, player.roundKills+player.roundHealPoints+player.roundStabKills);
        //ds_priority_add(blueteam, player, player.stats[KILLS]+2*player.stats[CAPS]+.5*player.stats[ASSISTS]+player.stats[DESTRUCTION]+player.stats[STABS]+floor(player.stats[HEALING]/200)+player.stats[DEFENSES]+player.stats[INVULNS]+player.stats[BONUS]);
        ds_priority_add(blueteam, player, player.roundStats[POINTS]);
    }
}

while ds_priority_size(redteam) > 3{
    ds_priority_delete_min(redteam);
}

while ds_priority_size(blueteam) > 3{
    ds_priority_delete_min(blueteam);
}

redMVPs = ds_priority_size(redteam);
blueMVPs = ds_priority_size(blueteam);

writebyte(ARENA_ENDROUND,global.eventBuffer);

writebyte(winners, global.eventBuffer);
writebyte(redMVPs, global.eventBuffer);
writebyte(blueMVPs, global.eventBuffer);
writebyte(consecutiveRedWins, global.eventBuffer);
writebyte(consecutiveBlueWins, global.eventBuffer);

for(i=0; i < redMVPs; i+=1) {
    redMVP[i] = ds_priority_delete_max(redteam);
    redMVPIndex[i] = ds_list_find_index(global.players,redMVP[i]);
    //redMVP[i].roundHealed = round(redMVP[i].roundHealed);
    redMVP[i].roundStats[HEALING] = round(redMVP[i].roundStats[HEALING]);
    writebyte(redMVPIndex[i], global.eventBuffer);
    //writebyte(redMVP[i].roundKills, global.eventBuffer);
    writebyte(redMVP[i].roundStats[KILLS], global.eventBuffer);
    //writebyte(redMVP[i].roundStabKills, global.eventBuffer);
    //writeshort(redMVP[i].roundHealed, global.eventBuffer);
    writeushort(redMVP[i].roundStats[HEALING], global.eventBuffer);
    //writebyte(redMVP[i].roundHealPoints, global.eventBuffer);
    writebyte(redMVP[i].roundStats[POINTS], global.eventBuffer);
}

for(i=0; i < blueMVPs; i+=1) {
    blueMVP[i] = ds_priority_delete_max(blueteam);
    blueMVPIndex[i] = ds_list_find_index(global.players,blueMVP[i]);
    //blueMVP[i].roundHealed = round(blueMVP[i].roundHealed);
    blueMVP[i].roundStats[HEALING] = round(blueMVP[i].roundStats[HEALING]);
    writebyte(blueMVPIndex[i], global.eventBuffer);
    //writebyte(blueMVP[i].roundKills, global.eventBuffer);
    writebyte(blueMVP[i].roundStats[KILLS], global.eventBuffer);
    //writebyte(blueMVP[i].roundStabKills, global.eventBuffer);
    //writeshort(blueMVP[i].roundHealed, global.eventBuffer);
    writeushort(blueMVP[i].roundStats[HEALING], global.eventBuffer);
    //writebyte(blueMVP[i].roundHealPoints, global.eventBuffer);
    writebyte(blueMVP[i].roundStats[POINTS], global.eventBuffer);
}

with Sentry if team != ArenaHUD.winners event_user(1);

ds_priority_destroy(redteam);
ds_priority_destroy(blueteam);

doEventArenaEndRound();
