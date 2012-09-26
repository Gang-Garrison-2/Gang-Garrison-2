{
    //argument0: The team which spawn group is seeked

    var team, group;
    team = argument0;
    
    if instance_exists(ControlPointHUD){ //capture point
        var myTeamCP, i;
        myTeamCP = 0;
        for (i=1; i<= global.totalControlPoints; i+=1) {
            if global.cp[i].team == team myTeamCP+=1;
        }
        if (ControlPointHUD.mode == 1) { //attack/defense
            if team == TEAM_RED group = myTeamCP;
            else if team == TEAM_BLUE group = myTeamCP - 1;
        } else if (ControlPointHUD.mode == 0) { //conventional CP
            var middlePoint;
            middlePoint = floor(global.totalControlPoints / 2);
            if myTeamCP >= middlePoint + 2 group = 2;
            else if myTeamCP >= middlePoint + 1 group = 1;
            else if myTeamCP <= middlePoint group = 0;
        }
    } else if instance_exists(KothHUD) { //King of the Hill
        group = (team == KothControlPoint.team);
    } else if instance_exists(DKothHUD) { //Dual King of the Hill
        var myTeamCP, i;
        myTeamCP = 0;
        for (i=1; i<= global.totalControlPoints; i+=1) {
            if global.cp[i].team == team myTeamCP+=1;
        }
        group = myTeamCP;
    } else { //any game mode that does not support forward spawns
        group = 0; 
    }
    while (group != -1 )
    {
        if team == TEAM_RED {
            if ds_list_empty(global.spawnPointsRed[0,group])
                group -=1;
            else break;
        }
        else if team == TEAM_BLUE {
            if ds_list_empty(global.spawnPointsBlue[0,group])
                group -=1;
            else break;
        }
    }
    return group;
}
