//if (global.myself.canRespawn == true)
//{
/*
if (global.myself.class != CLASS_CIVILIAN)
{
*/

//arena mode - prevent change of team or class
//before the round starts
//otherwise the player can't respawn until next round
if instance_exists(ArenaHUD) {
    //if ArenaHUD.roundStart == 0 && ArenaHUD.endCount == 0 exit;
    if ArenaHUD.roundStart == 0 && ArenaHUD.endCount == 0 && global.myself.object != -1 exit;
}

if (global.mapchanging != 1)
{
ClassSelectController.done = true;
    if !instance_exists(TeamSelectController)
    {
        instance_create(0,0,TeamSelectController);      
    }
    
    else if(instance_exists(TeamSelectController)) 
    {
        TeamSelectController.done = true;
    }   
}
else if (global.mapchanging == 1)
{
    TeamSelectController.done = true;
}
//}
//}
