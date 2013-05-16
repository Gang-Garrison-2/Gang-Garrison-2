// if displaying console in in-game menu
if (global.consoleMode && !instance_exists(MenuController)) {
    instance_create(0, 0, InGameMenuController);
}

if (!instance_exists(Console))
{
    instance_create(x, y, Console);
}
