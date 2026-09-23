// EngineOptionsController: menu_addedit_select("Ingame Aspect Ratio:")
gg2_write_ini("Settings", "Resolution", argument0);
if(room != Options)
    warnoptioneffect = !global.isHost;
global.changed_resolution = true;
