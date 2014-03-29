    // Record kill in killlog
    // argument0: The killed player
    // argument1: The killer, or -1 for selfkills/unknown cause of death
    // argument2: The source of the damage (e.g. WEAPON_SCATTERGUN)
    
        with (KillLog) {
            map = ds_map_create();
            if (argument1==-1) {
                ds_map_add(map, 0, "");
                ds_map_add(map, 1, 0);
            } else {
                ds_map_add(map, 0, string_copy(argument1.name, 1, 20));
                ds_map_add(map, 1, argument1.team);
            }
            
            switch(argument2) {
                case WEAPON_NEEDLEGUN:
                    ds_map_add(map, 2, BlutSaugerS);
                    break;
                case WEAPON_RIFLE:
                    ds_map_add(map, 2, RifleS);
                    break;
                case WEAPON_MINEGUN:
                    ds_map_add(map, 2, MinegunS);
                    break;
                case WEAPON_MINIGUN:
                    ds_map_add(map, 2, MinigunS);
                    break;
                case WEAPON_FLAMETHROWER:
                    ds_map_add(map, 2, FlamethrowerS);
                    break;
                case WEAPON_SCATTERGUN:
                    ds_map_add(map, 2, ScattergunS);
                    break;
                case WEAPON_SHOTGUN:
                    ds_map_add(map, 2, ShotgunS);
                    break;
                case WEAPON_QROCKETLAUNCHER:
                    ds_map_add(map, 2, QRlauncherS);
                    break;
                case WEAPON_ROCKETLAUNCHER:
                    ds_map_add(map, 2, RocketlauncherS);
                    break;
                case WEAPON_REVOLVER:
                    ds_map_add(map, 2, RevolverS);
                    break;
                case WEAPON_SENTRYTURRET:
                    ds_map_add(map, 2, SentryTurretS);
                    break;
                case WEAPON_BLADE:
                    ds_map_add(map, 2, BladeS);
                    break;
                case WEAPON_KNIFE:
                    ds_map_add(map, 2, KnifeS);
                    break;
                case WEAPON_BLADE2:
                    ds_map_add(map, 2, BladeBS);
                    break;
                case WEAPON_REFLECT:
                    ds_map_add(map, 2, ReflectS);
                    break;
                case WEAPON_SMG:
                    ds_map_add(map, 2, smgS);
                    break;
                default:
                    ds_map_add(map, 2, DeadS);
            }
            
            
            ds_map_add(map, 3, string_copy(argument0.name, 1, 20));
            ds_map_add(map, 4, argument0.team);
            
            ds_list_add(kills, map);
            
            if (ds_list_size(kills) > 5) {
                ds_map_destroy(ds_list_find_value(kills, 0));
                ds_list_delete(kills, 0);
            }
            
            alarm[0] = 30*5;
        }