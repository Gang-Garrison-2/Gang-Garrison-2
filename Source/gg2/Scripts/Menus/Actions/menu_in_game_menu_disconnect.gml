// InGameMenuController: menu_addlink("Disconnect")
// Force dedicated mode to off so you can go to main menu instead of just restarting server
if (show_question("Do you really want to leave this match?")) {
    // PLUGINS(disabled): no runtime GML execution in ENIGMA; revisit
    // if (global.serverPluginsInUse)
    // {
    //     pluginscleanup(true);
    // }
    // else
    // {
    {
        global.dedicatedMode = 0;
        with(Client)
            instance_destroy();

        with(GameServer)
            instance_destroy();
    }
}
