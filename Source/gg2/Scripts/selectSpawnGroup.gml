{
    //argument0: The team which spawn group is seeked

    var team, group;
    team = argument0;
    
    if (instance_exists(ControlPointHUD)) // Gamemode is CP
    {
        var myTeamCP, i;
        myTeamCP = 0;
        for (i=1; i<= global.totalControlPoints; i+=1)
        {
            if (global.cp[i].team == team)
                myTeamCP += 1;
        }
        if (ControlPointHUD.mode == 1) // assault CP (A/D)
        {
            if (team == TEAM_RED)
                group = myTeamCP;
            else if (team == TEAM_BLUE)
                group = myTeamCP - 1;
        }
        else if (ControlPointHUD.mode == 0) // push CP (symmetric)
        {
            var middlePoint;
            middlePoint = floor(global.totalControlPoints / 2);
            if (myTeamCP >= middlePoint + 2)
                group = 2;
            else if (myTeamCP >= middlePoint + 1)
                group = 1;
            else if (myTeamCP <= middlePoint)
                group = 0;
        }
    }
    else if instance_exists(KothHUD) //King of the Hill
        group = (team == KothControlPoint.team);
    else if instance_exists(DKothHUD) //Dual King of the Hill
    {
        var myTeamCP, i;
        myTeamCP = 0;
        for (i=1; i<= global.totalControlPoints; i+=1)
        {
            if (global.cp[i].team == team)
                myTeamCP += 1;
        }
        group = myTeamCP;
    }
    else // game mode does not support forward spawns
    {
        group = 0; 
    }
    if (group != -1) while (group > 0)
    {
        if (team == TEAM_RED)
        {
            if (ds_list_empty(global.spawnPointsRed[0,group]))
                group -= 1;
            else
                break;
            
        }
        else if (team == TEAM_BLUE)
        {
            if (ds_list_empty(global.spawnPointsBlue[0,group]))
                group -= 1;
            else
                break;
            
        }
    }
    // Fallback to prevent game from crashing when a negative (invalid) spawn would be been returned
    // Happens when a BLU respawns on A/D while owning zero control points -- SHOULD never happen, but MIGHT
    return max(0, group);
}
