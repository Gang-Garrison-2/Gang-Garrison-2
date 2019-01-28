// arena mode - prevent change of team or class after the round starts
// otherwise the player can't respawn until next round
if instance_exists(ArenaHUD) {
    if (ArenaHUD.state == ArenaHUD.ARENA_STATE_ROUND_PROPER and global.myself.object != -1) exit;
}

if (!global.mapchanging)
{
    TeamSelectController.done = true;
    if !instance_exists(ClassSelectController)
        instance_create(0,0,ClassSelectController);
    else
        ClassSelectController.done = true;
}
else
    ClassSelectController.done = true;

