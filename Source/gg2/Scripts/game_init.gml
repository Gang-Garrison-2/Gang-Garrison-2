{
    
    var customMapRotationFile;

    global.receiveBuffer = createbuffer();
    global.sendBuffer = createbuffer();
    global.tempBuffer = createbuffer();
    
    global.map_rotation = ds_list_create();
    
    global.CustomMapCollisionSprite = -1;
    
    window_set_region_scale(-1, false);
    
    ini_open("gg2.ini");
    global.playerName = ini_read_string("Settings", "PlayerName", "Player");
    global.playerName = string_copy(global.playerName, 0, min(string_length(global.playerName), MAX_PLAYERNAME_LENGTH));
    global.fullscreen = ini_read_real("Settings", "Fullscreen", 0);
    global.useLobbyServer = ini_read_real("Settings", "UseLobby", 1);
    global.hostingPort = ini_read_real("Settings", "HostingPort", 8190);
    global.ingameMusic = ini_read_real("Settings", "IngameMusic", 1);
    global.playerLimit = ini_read_real("Settings", "PlayerLimit", 10);
    customMapRotationFile = ini_read_string("Server", "MapRotation", "");
    global.dedicatedMode = ini_read_real("Server", "Dedicated", 0);
    global.defaultServerName = ini_read_string("Server", "ServerName", "My Server");
    global.caplimit = ini_read_real("Server", "CapLimit", 5);
    
    ini_write_string("Settings", "PlayerName", global.playerName);
    ini_write_real("Settings", "Fullscreen", global.fullscreen);
    ini_write_real("Settings", "UseLobby", global.useLobbyServer);
    ini_write_real("Settings", "HostingPort", global.hostingPort);
    ini_write_real("Settings", "IngameMusic", global.ingameMusic);
    ini_write_real("Settings", "PlayerLimit", global.playerLimit);
    ini_write_string("Server", "MapRotation", customMapRotationFile);
    ini_write_real("Server", "Dedicated", global.dedicatedMode);
    ini_write_string("Server", "ServerName", global.defaultServerName);
    ini_write_real("Server", "CapLimit", global.caplimit);
    
    //screw the 0 index we will start with 1
    //map_2dfort 
    maps[1] = ini_read_real("Maps", "2dfort", 1);
    //map_2dfort2 
    maps[2] = ini_read_real("Maps", "2dfort2", 2);
    //map_helltrikky_1 
    maps[3] = ini_read_real("Maps", "helltrikky_1", 3);
    //map_classicwell 
    maps[4] = ini_read_real("Maps", "classicwell", 4);
    //map_orange 
    maps[5] = ini_read_real("Maps", "orange", 5);
    //map_avanti 
    maps[6] = ini_read_real("Maps", "avanti", 6);
    //map_castle 
    maps[7] = ini_read_real("Maps", "castle", 7);
    //map_containment 
    maps[8] = ini_read_real("Maps", "containment", 8);
    //map_heenok 
    maps[9] = ini_read_real("Maps", "heenok", 9);
    
    ini_write_real("Maps", "2dfort", maps[1]);
    ini_write_real("Maps", "2dfort2", maps[2]);
    ini_write_real("Maps", "helltrikky_1", maps[3]);
    ini_write_real("Maps", "classicwell", maps[4]);
    ini_write_real("Maps", "orange", maps[5]);
    ini_write_real("Maps", "avanti", maps[6]);
    ini_write_real("Maps", "castle", maps[7]);
    ini_write_real("Maps", "containment", maps[8]);
    ini_write_real("Maps", "heenok", maps[9]);

    ini_close();
    
    // if the user defined a valid map rotation file, then load from there

    if(customMapRotationFile != "" && file_exists(customMapRotationFile)) {
        var fileHandle, i, mapname;
        fileHandle = file_text_open_read(customMapRotationFile);
        for(i = 1; !file_text_eof(fileHandle); i += 1) {
            mapname = file_text_read_string(fileHandle);
            if(mapname != "") {
                ds_list_add(global.map_rotation, mapname);
            }
            file_text_readln(fileHandle);
        }
    } else { // else load from the ini file Maps section
        //Set up the map rotation stuff
        var i, sort_list;
        sort_list = ds_list_create();
        for(i=1; i < 10; i += 1) {
            if(maps[i] != 0) ds_list_add(sort_list, ((100*maps[i])+i));
        }
        ds_list_sort(sort_list, 1);
        
        // translate the numbers back into the names they represent
        for(i=1; i < ds_list_size(sort_list); i += 1) {
            switch(ds_list_find_value(sort_list, i) mod 100) {
                case 1:
                    ds_list_add(global.map_rotation, "2dfort");
                break;
                case 2:
                    ds_list_add(global.map_rotation, "2dfort_2");
                break;
                case 3:
                    ds_list_add(global.map_rotation, "helltrikky_1");
                break;
                case 4:
                    ds_list_add(global.map_rotation, "classicwell");
                break;
                case 5:
                    ds_list_add(global.map_rotation, "Orange");
                break;
                case 6:
                    ds_list_add(global.map_rotation, "Avanti");
                break;
                case 7:
                    ds_list_add(global.map_rotation, "Castle");
                break;
                case 8:
                    ds_list_add(global.map_rotation, "Containment");
                break;
                case 9:
                    ds_list_add(global.map_rotation, "Heenok");
                break;
            }
        }
        ds_list_destroy(sort_list);
    }
    
    window_set_fullscreen(global.fullscreen);
    
    draw_set_font(fnt_Com);
    cursor_sprite = CrosshairS;
    
    if(!directory_exists(working_directory + "\Maps")) directory_create(working_directory + "\Maps");
    
    instance_create(0, 0, AudioControl);
    
    var a;
    for(a = 1; a <= parameter_count(); a += 1) {
        if(parameter_string(a) == "-dedicated") global.dedicatedMode = 1;
    }
    
    if(global.dedicatedMode == 1) {
        AudioControlToggleMute();
        room_goto(Menu);
    }
}