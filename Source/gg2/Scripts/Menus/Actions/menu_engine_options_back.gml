// EngineOptionsController: menu_addback("Back")
if(warnoptioneffect)
    show_message("An option you changed only takes effect on map change or server join.");
instance_destroy();
if(room == Options)
    room_goto_fix(Menu);
else
    instance_create(0,0,InGameMenuController);
