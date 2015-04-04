{
    // Argument 0: Team
    // Argument 1: Class

    var classObjects, result;
        
    classObjects = ds_map_find_value(global.teamMap, argument0);
    if(classObjects == 0)
        return -1;
        
    result = ds_map_find_value(classObjects, argument1);
    if(result == 0)
        return -1;
        
    return result;
}
