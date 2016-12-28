{
    // Argument 0: Class
    var result;
        
    result = ds_map_find_value(global.characterMap, argument0);
    if(result == 0)
        return -1;
        
    return result;
}
