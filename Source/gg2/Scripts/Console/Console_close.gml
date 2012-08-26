with Console
{
    instance_destroy();
}
global.consoleIsOpen = false;

with InGameMenuController
{
    menu_change_option(2, "Open Console", "Console_open()");
}
