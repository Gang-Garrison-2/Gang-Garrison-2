instance_create(0, 0, Console);
global.consoleIsOpen = true;
with InGameMenuController
{
    menu_change_option(2, "Close Console", "Console_close()");
}
