{
    // Argument 0: Team
    // Argument 1: Class
    
    teamMap = ds_map_find_value(global.teamMap, argument0);
    //prevent variable clashing
    _class = ds_map_find_value(teamMap, argument1);
    if (teamMap == -1)
    {
        show_error("An invalid team was requested", false);
    }
    if (_class == -1)
    {
        show_error("An invalid class was requested", false);
    }
    else
        return _class;
}
