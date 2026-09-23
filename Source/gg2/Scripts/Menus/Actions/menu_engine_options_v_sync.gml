// EngineOptionsController: menu_addedit_select("V Sync:")
gg2_write_ini("Settings", "Monitor Sync", argument0);
if (!instance_exists(GameServer))
    set_synchronization(argument0);
