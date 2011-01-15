//auto balance 
    redteam = 0;
    blueteam = 0;  
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        if(player.team == TEAM_RED) {
            redteam+=1;
        } else if (player.team == TEAM_BLUE) {
            blueteam+=1;    
        }
    }

    teammore = TEAM_SPECTATOR;
    teamless = TEAM_SPECTATOR;
    
    if(redteam >= blueteam + 2) {
        balance=TEAM_RED;
        teammore = redteam;
        teamless = blueteam;
    } else if(blueteam >= redteam + 2) {
        balance=TEAM_BLUE;
        teammore = blueteam;
        teamless = redteam;
    } 
    
    if teammore != TEAM_SPECTATOR {
        while teammore >= teamless + 2 {
            points=9001;
            balanceplayer=-1;
            for(i=0; i<ds_list_size(global.players); i+=1) {
                player = ds_list_find_value(global.players, i);
                //if(player.team == balance && player.kills+(player.caps*2)+player.healpoints < points) {
                if (player.team == balance && player.stats[POINTS] < points) {
                    //points=player.kills+(player.caps*2)+player.healpoints;
                    points=player.stats[POINTS];
                    balanceplayer=player;
                }
            }
        
            serverbalance=0;
            balancecounter=0;
        
            if(balanceplayer.team==TEAM_RED) {
                balanceplayer.team = TEAM_BLUE;
            } else {
                balanceplayer.team = TEAM_RED;
            }
        
            if(balanceplayer.object != -1) {
                with(balanceplayer.object) {
                    instance_destroy();
                }
                balanceplayer.object = -1;
            }
        
            write_ubyte(global.eventBuffer, BALANCE);
            write_ubyte(global.eventBuffer, ds_list_find_index(global.players, balanceplayer));
            if !instance_exists(Balancer) instance_create(x,y,Balancer);
            Balancer.name=player.name;
            with (Balancer) notice=1;
            teammore-=1;
            teamless+=1;
        }
    }
    
    with Player {
        canSpawn = 1;
        if object != -1 with object instance_destroy();
        alarm[5] = 1;
    }
    
    sendEventArenaRestart();
    doEventArenaRestart();
