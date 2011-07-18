//arena mode - prevent change of team or class
//before the round starts
//otherwise the player can't respawn until next round
if instance_exists(ArenaHUD) {
    if ArenaHUD.roundStart == 0 && ArenaHUD.endCount == 0 && global.myself.object != -1 exit;
}

if (!global.mapchanging)
{
    ClassSelectController.done = true;
    if !instance_exists(TeamSelectController)
        instance_create(0,0,TeamSelectController);
    else
        TeamSelectController.done = true;
}
else
    TeamSelectController.done = true;
