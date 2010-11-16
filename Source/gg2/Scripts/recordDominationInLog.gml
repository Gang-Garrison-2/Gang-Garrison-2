    // Record domination in killlog
    // argument0: The killed player  
    // argument1: The Dominating player
    // argument2: 0 for DOMINATION, 1 for REVENGE
        
        with (KillLog) {
            map = ds_map_create(); 
            var killer, victim, inthis;
            killer = string_copy(argument0.name, 1, 20);
            victim = string_copy(argument1.name, 1, 20);
            if (argument0 == global.myself) || (argument1 == global.myself) {
                inthis = true;
                if (!argument2)
                    sound_play(DominationSnd);
                else
                    sound_play(RevengeSnd);
            }
            ds_map_add(map, "name1", killer);
            ds_map_add(map, "team1", argument1.team);
            ds_map_add(map, "weapon", DominationKL);
            if (!argument2)
                ds_map_add(map, "string", "is DOMINATING ");
            else
                ds_map_add(map, "string", "got REVENGE on ");
            ds_map_add(map, "name2", victim);
            ds_map_add(map, "team2", argument0.team);
            ds_map_add(map, "inthis", inthis);
                        
            ds_list_add(kills, map);
            
            if (ds_list_size(kills) > 5) {
                ds_map_destroy(ds_list_find_value(kills, 0));
                ds_list_delete(kills, 0);
            }
            
            alarm[0] = 30*5;
        }
