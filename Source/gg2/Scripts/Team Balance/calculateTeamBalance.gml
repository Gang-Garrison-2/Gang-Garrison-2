var redSuperiority;
redteam=0;
blueteam=0;
redSuperiority = 0
for(i=0; i<ds_list_size(global.players); i+=1) {
    player = ds_list_find_value(global.players, i);
    if(player.team == TEAM_RED) {
        redteam+=1;
        if(player != global.myself) {
            redSuperiority += 1;
        }
    } else if (player.team == TEAM_BLUE) {
        blueteam+=1;
        if(player != global.myself) {
            redSuperiority -= 1;   
        }
    }
}

if(redSuperiority > 0) return TEAM_RED;
else if(redSuperiority < 0) return TEAM_BLUE;
else return -1;