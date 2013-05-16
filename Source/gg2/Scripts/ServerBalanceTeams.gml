// auto balance, called on Character death
if global.autobalance == 1 && !instance_exists(ArenaHUD) {
    // calculate team sizes
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

    // figure out if imbalanced
    if(redteam >= blueteam + 2) {
        balance=TEAM_RED;
    } else if(blueteam >= redteam + 2) {
        balance=TEAM_BLUE;
    // if balanced, reset counter
    } else {
        serverbalance=0;
        balancecounter=0;
        exit;
    }
    
    // Stage 1) autobalance notice, start counter
    if(serverbalance==0) {
        write_ubyte(global.sendBuffer, BALANCE);
        write_ubyte(global.sendBuffer, 255);
        if !instance_exists(Balancer) instance_create(x,y,Balancer);
        with(Balancer) notice=0;
        serverbalance=1;
    // Stage 2) balance teams after counter reaches respawn time + 2 seconds
    } else if(serverbalance == 1 && balancecounter >= (global.Server_Respawntime + 30*2)) {
        points=9001;
        balanceplayer=-1;
        for(i=0; i<ds_list_size(global.players); i+=1) {
            player = ds_list_find_value(global.players, i);
            // find lowest pointed player on larger team
            if(player.team == balance && player.stats[POINTS] < points) {
                // Only dead players
                if (player.object != -1) {
                    if (!(player.object.hp <= 0)) {
                        continue;
                    }
                }
                points = player.stats[POINTS];
                balanceplayer=player;
            }
        }
        
        // if no suitable player found, wait until next time
        if (balanceplayer == -1) exit;

        // clear counter
        serverbalance=0;
        balancecounter=0;

        // do team switch
        
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
        
        write_ubyte(global.sendBuffer, BALANCE);
        write_ubyte(global.sendBuffer, ds_list_find_index(global.players, balanceplayer));
        if !instance_exists(Balancer) instance_create(x,y,Balancer);
        Balancer.name=player.name;
        with (Balancer) notice=1;
    }
} 
