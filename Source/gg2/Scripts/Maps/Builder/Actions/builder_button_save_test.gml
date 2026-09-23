// builder_init: addButton("Save & test")
if (Builder.mapWM == "") show_message("Select a walkmask first.");
else if (Builder.mapBG == "") show_message("Select a background first");
else if (validateMap(log2(gamemode))) {    
    var leveldata;
    leveldata = compressEntities() + chr(10) + Builder.wmString;
    GG2DLL_embed_PNG_leveldata(Builder.mapBG, leveldata);

    // Place a copy in the maps folder
    if (file_exists("Maps\ggb2_tmp_map.png")) file_delete("Maps\ggb2_tmp_map.png");
    file_copy(Builder.mapBG, "Maps\ggb2_tmp_map.png");

    switch(show_message_ext("Compilation completed. The map is saved to " + string(Builder.mapBG) + ".", "Ok", "Test separately", "Test here")) {
        case 2:             
            startGG2("-map ggb2_tmp_map");
        break;       
        case 3:
            Builder.selected = -1;
            Builder.visible = false;
            global.launchMap = "ggb2_tmp_map";
            global.isHost = true;
            global.gameServer = instance_create(0,0,GameServer); 
        break; 
    }
}
