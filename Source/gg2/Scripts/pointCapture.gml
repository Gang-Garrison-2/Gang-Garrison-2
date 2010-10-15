//argument0 = the effected control point no.

var soundPlayed;
soundPlayed=false;

point = global.cp[argument0];
capList = ds_list_create();
   
with(Character) {
    if(cappingPoint == other.point) {
        if(player.team == other.point.cappingTeam) {
            ds_list_add(other.capList, player);
            player.caps +=1;
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
    
recordEventInLog(1, point.cappingTeam, capperList);
ds_list_destroy(capList);
        
with point {
    team = cappingTeam;
    capping = 0;
}

if(not soundPlayed) {
    playsound(x,y,CPCapturedSnd);
}
sound_play(IntelPutSnd);
