// builder_init: addButton("Test w/o save")
if (Builder.mapWM == "") show_message("Select a walkmask first.");
else if (Builder.mapBG == "") show_message("Select a background first");
else if (validateMap(log2(gamemode))) {
    // Save to a temporary file
    if (file_exists("Maps\ggb2_tmp_map.png")) file_delete("Maps\ggb2_tmp_map.png");
    file_copy(Builder.mapBG, "Maps\ggb2_tmp_map.png");

    var leveldata;
    leveldata = compressEntities() + chr(10) + Builder.wmString;
    GG2DLL_embed_PNG_leveldata("Maps/ggb2_tmp_map.png", leveldata);               

    switch(show_message_ext("Where do you want to playtest?", "Test separately", "Test here", "Cancel")) {
        case 1:             
            startGG2("-map ggb2_tmp_map");
        break;       
        case 2:
            Builder.selected = -1;
            Builder.visible = false;
            global.launchMap = "ggb2_tmp_map";
            global.isHost = true;
            global.gameServer = instance_create(0,0,GameServer); 
        break; 
    }          
}
