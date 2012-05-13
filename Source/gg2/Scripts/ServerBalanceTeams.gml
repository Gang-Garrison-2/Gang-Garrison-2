//auto balance 
if global.autobalance == 1 && !instance_exists(ArenaHUD) {
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

    if(redteam >= blueteam + 2) {
        balance=TEAM_RED;
    } else if(blueteam >= redteam + 2) {
        balance=TEAM_BLUE;
    } else {
        exit;
    }
    
    if(serverbalance==0) {
        write_ubyte(global.eventBuffer, BALANCE);
        write_ubyte(global.eventBuffer, 255);
        if !instance_exists(Balancer) instance_create(x,y,Balancer);
        with(Balancer) notice=0;
        serverbalance=1;
    } else if(serverbalance == 1 && balancecounter >= 150) {
        points=9001;
        balanceplayer=-1;
        var someoneIsDead;
        someoneIsDead = false;
        for(i=0; i<ds_list_size(global.players); i+=1) {
            player = ds_list_find_value(global.players, i);
            if player.team == balance
            {
                if someoneIsDead
                {
                    if player.object == -1
                    {
                        if player.stats[POINTS] < points
                        {
                            points = player.stats[POINTS];
                            balanceplayer=player;
                        }
                    }
                }
                else
                {
                    if player.object != -1
                    {
                        if player.object.intel or player.object.ubered
                        {
                            continue;// Skip the player if he/she has taken the intel
                        }
                        else if player.stats[POINTS] < points
                        {
                            points = player.stats[POINTS];
                            balanceplayer=player;
                        }
                    }
                    else
                    {
                        someoneIsDead = true;
                        points = player.stats[POINTS];
                        balanceplayer=player;   
                    }
                }
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
            balanceplayer.alarm[5] = global.Server_Respawntime;
        }
        
        write_ubyte(global.eventBuffer, BALANCE);
        write_ubyte(global.eventBuffer, ds_list_find_index(global.players, balanceplayer));
        if !instance_exists(Balancer) instance_create(x,y,Balancer);
        Balancer.name=player.name;
        with (Balancer) notice=1;
    } else {
        serverbalance=0;
        balancecounter=0;
    }
} 
