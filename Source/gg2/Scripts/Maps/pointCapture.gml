//argument0 = the effected control point no.

var soundPlayed;
soundPlayed=false;
IntelPutSnd = faudio_new_generator(IntelPutSndS);
point = global.cp[argument0];
capList = ds_list_create();

var imInvolved;
imInvolved = false;
with(Character) {
    if(cappingPoint == other.point) {
        if(player.team == other.point.cappingTeam) {
            ds_list_add(other.capList, player);
            player.stats[CAPS] +=1;
            player.roundStats[CAPS] +=1;
            player.stats[POINTS] += 2;
            player.roundStats[POINTS] += 2;
            if (player == global.myself) imInvolved = true;
        }
        if(player == global.myself) {
            playsound(x,y,CPCapturedSnd);
            soundPlayed = true;
        }
    }
}

var capperList;
capperList = "";

for(i=0; i<ds_list_size(capList); i+=1) {
    player = ds_list_find_value(capList,i);            
        
    if (i == 0) {
        capperList=capperList + player.name;
    } else {
        if i == ds_list_size(capList)-1 capperList=capperList + " and " + player.name;
        else capperList=capperList + ", " + player.name;
    }
}    
    
faudio_fire_generator(IntelPutSnd);
recordEventInLog(1, point.cappingTeam, capperList, imInvolved);
ds_list_destroy(capList);

with point {
    team = cappingTeam;
    capping = 0;
}
CPCapturedSnd = faudio_new_generator(CPCapturedSndS);
if(not soundPlayed) {
    playsound(x,y,CPCapturedSnd);
}
faudio_kill_generator(IntelPutSnd);
faudio_kill_generator(CPCapturedSnd);
