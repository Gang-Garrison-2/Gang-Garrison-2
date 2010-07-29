//argument0 = the effected control point no.
point = global.cp[argument0];
       
capList = ds_list_create();
capperList = "";
    
totalPlayers = instance_number(Character);
for(i=0;i<totalPlayers;i+=1){
    capcheck=instance_find(Character,i);
    if capcheck.inZone == 1 {
        if capcheck.player.team == point.capTeam && capcheck.zone.cp == point.object_index {
            ds_list_add(capList, capcheck.player);
            capcheck.player.caps +=1;
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
    
recordEventInLog(1, capTeam, capperList);
ds_list_destroy(capList);  
capperList = "";
        
with point {
    team = capTeam;
    capping = 0;
}

playsound(x,y,CPCapturedSnd);
sound_play(IntelPutSnd);
