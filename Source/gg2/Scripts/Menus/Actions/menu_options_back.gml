// Options menus (Options, Controls, AdvControls, EngineOptions, HUDOptions): menu_addback("Back")
instance_destroy();
if(room == Options)
    room_goto_fix(Menu);
else
    instance_create(0,0,InGameMenuController);
