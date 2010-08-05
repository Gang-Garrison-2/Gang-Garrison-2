//argument0 = the effected control point no.
point = global.cp[argument0];
       
capList = ds_list_create();
capperList = "";
var imInvolved;
imInvolved = false;    
totalPlayers = instance_number(Character);
for(i=0;i<totalPlayers;i+=1){
    capcheck=instance_find(Character,i);
    if capcheck.inZone == 1 {
        if capcheck.player.team == point.capTeam && capcheck.zone.cp == point.object_index {
            ds_list_add(capList, capcheck.player);
            capcheck.player.stats[CAPS] +=1;
            capcheck.player.roundStats[CAPS] +=1;
            capcheck.player.stats[POINTS] += 2;
            capcheck.player.roundStats[POINTS] += 2;
            if (capcheck.player = global.myself) imInvolved = true;
        }
    }
}

for(i=0; i<ds_list_size(capList); i+=1) {
    player = ds_list_find_value(capList,i);            
        
    if (i == 0)
    {
        capperList=capperList + player.name;
    }
    else
    {
        if i == ds_list_size(capList)-1 capperList=capperList + " and " + player.name;
        else capperList=capperList + ", " + player.name;
    }

}    
    
recordEventInLog(1, capTeam, capperList, imInvolved);
ds_list_destroy(capList);  
capperList = "";
        
with point {
    team = capTeam;
    capping = 0;
}

playsound(x,y,CPCapturedSnd);
sound_play(IntelPutSnd);
