//if (global.myself.canRespawn == true)
//{
/* for VIP. Citizen player cannot change class after they become one.
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
TeamSelectController.done = true;
    if !instance_exists(ClassSelectController)
    {
        instance_create(0,0,ClassSelectController);      
    }
    
    else if(instance_exists(ClassSelectController)) 
    {
        ClassSelectController.done = true;
    }   
}
else if (global.mapchanging == 1)
{
    ClassSelectController.done = true;
}
//}

