// if displaying console in in-game menu
if (global.consoleMode == CONSOLE_INMENU && !instance_exists(MenuController)) {
    instance_create(0, 0, InGameMenuController);
}

// Not disabled
if (!instance_exists(Console) && (global.consoleMode != CONSOLE_DISABLED))
{
    instance_create(0, 300, Console);
}
