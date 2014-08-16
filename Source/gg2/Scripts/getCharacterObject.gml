{
    // Argument 0: Team
    // Argument 1: Class
    
    teamMap = ds_map_find_value(global.teamMap, argument0);
    return ds_map_find_value(teamMap, argument1);
}
