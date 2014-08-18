    // Record destruction in killlog
    // argument0: The owner of the destroyed building
    // argument1: The killer
    // argument2: The healer, or -1 for no assist
    // argument3: The source of the damage (e.g. DAMAGE_SOURCE_SCATTERGUN)
      
        with (KillLog) {
            map = ds_map_create();
            var killer;
            killer = string_copy(argument1.name, 1, 20);
            if (instance_exists(argument2))
                killer += " + " + string_copy(argument2.name, 1, 20);
            ds_map_add(map, "name1", killer);
            ds_map_add(map, "team1", argument1.team);
            
            if(argument3 == DAMAGE_SOURCE_BID_FAREWELL)
            {
                ds_map_add(map, "name2", "");
                ds_map_add(map, "team2", 0);
            }
            else
            {
                ds_map_add(map, "name2", "Autogun (" + string_copy(argument0.name, 1, 20) + ")");
                ds_map_add(map, "team2", argument0.team);
            }
            
            if (argument0 == global.myself || argument1 == global.myself || argument2 == global.myself) 
                ds_map_add(map, "inthis", true);
            else ds_map_add(map, "inthis", false);
            
            ds_map_add(map, "weapon", findDamageSourceIcon(argument3));
            
            switch(argument3) {
                case DAMAGE_SOURCE_FINISHED_OFF:
                case DAMAGE_SOURCE_FINISHED_OFF_GIB:
                    ds_map_add(map, "string", "finished off ");
                    break;
                case DAMAGE_SOURCE_BID_FAREWELL:
                    ds_map_add(map, "string", string_copy(argument0.name, 1, 20) + " bid farewell, cruel world!");
                    break;
                default:
                    ds_map_add(map, "string", "");
                    break;
            }
            
            ds_list_add(kills, map);
            
            if (ds_list_size(kills) > 5) {
                ds_map_destroy(ds_list_find_value(kills, 0));
                ds_list_delete(kills, 0);
            }
            
            alarm[0] = 30*5;
        }
