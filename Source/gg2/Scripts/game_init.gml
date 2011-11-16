{
    instance_create(0,0,RoomChangeObserver);
    set_little_endian_global(true);
    if file_exists("game_errors.log") file_delete("game_errors.log");
    
    var customMapRotationFile;

    //import wav files for music
    global.MenuMusic=sound_add(choose("Music/menumusic1.wav","Music/menumusic2.wav","Music/menumusic3.wav","Music/menumusic4.wav","Music/menumusic5.wav","Music/menumusic6.wav"), 1, true);
    global.IngameMusic=sound_add("Music/ingamemusic.wav", 1, true);
    global.FaucetMusic=sound_add("Music/faucetmusic.wav", 1, true);
    if(global.MenuMusic != -1)
        sound_volume(global.MenuMusic, 0.8);
    if(global.IngameMusic != -1)
        sound_volume(global.IngameMusic, 0.8);
    if(global.FaucetMusic != -1)
        sound_volume(global.FaucetMusic, 0.8);
        

    global.sendBuffer = buffer_create();
    global.eventBuffer = buffer_create();
    global.tempBuffer = buffer_create();
    global.HudCheck = false;
    global.map_rotation = ds_list_create();
    
    global.CustomMapCollisionSprite = -1;
    
    window_set_region_scale(-1, false);
    
    ini_open("gg2.ini");
    global.playerName = ini_read_string("Settings", "PlayerName", "Player");
    if string_count("#",global.playerName) > 0 global.playerName = "Player";
    global.playerName = string_copy(global.playerName, 0, min(string_length(global.playerName), MAX_PLAYERNAME_LENGTH));
    global.fullscreen = ini_read_real("Settings", "Fullscreen", 0);
    global.useLobbyServer = ini_read_real("Settings", "UseLobby", 1);
    global.hostingPort = ini_read_real("Settings", "HostingPort", 8190);
    global.ingameMusic = ini_read_real("Settings", "IngameMusic", 1);
    global.playerLimit = ini_read_real("Settings", "PlayerLimit", 10);
    global.particles =  ini_read_real("Settings", "Particles", PARTICLES_NORMAL);
    global.gibLevel = ini_read_real("Settings", "Gib Level", 3);
    global.killCam = ini_read_real("Settings", "Kill Cam", 1);
    global.monitorSync = ini_read_real("Settings", "Monitor Sync", 0);
    if global.monitorSync == 1 set_synchronization(true);
    else set_synchronization(false);
    global.medicRadar = ini_read_real("Settings", "Healer Radar", 1);
    global.showHealer = ini_read_real("Settings", "Show Healer", 1);
    global.showHealing = ini_read_real("Settings", "Show Healing",1);
    global.showHealthBar = ini_read_real("Settings", "Show Healthbar",0);
    //user HUD settings
    global.timerPos=ini_read_real("Settings","Timer Position", 0)
    global.killLogPos=ini_read_real("Settings","Kill Log Position", 0)
    global.kothHudPos=ini_read_real("Settings","KoTH HUD Position", 0)
    global.clientPassword = "";
    // for admin menu
    customMapRotationFile = ini_read_string("Server", "MapRotation", "");
    global.timeLimitMins = max(1, min(255, ini_read_real("Server", "Time Limit", 15)));
    global.serverPassword = ini_read_string("Server", "Password", "");
    global.mapRotationFile = customMapRotationFile;
    global.dedicatedMode = ini_read_real("Server", "Dedicated", 0);
    global.serverName = ini_read_string("Server", "ServerName", "My Server");
    global.caplimit = max(1, min(255, ini_read_real("Server", "CapLimit", 5)));
    global.caplimitBkup = global.caplimit;
    global.autobalance = ini_read_real("Server", "AutoBalance",1);
    global.Server_RespawntimeSec = ini_read_real("Server", "Respawn Time", 5);
    global.haxxyKey = ini_read_string("Haxxy", "SecretHaxxyKey", "");
    global.mapdownloadLimitBps = ini_read_real("Server", "Total bandwidth limit for map downloads in bytes per second", 50000);
    global.currentMapArea=1;
    global.totalMapAreas=1;
    global.setupTimer=1800;
    global.joinedServerName="";
        
    ini_write_string("Settings", "PlayerName", global.playerName);
    ini_write_real("Settings", "Fullscreen", global.fullscreen);
    ini_write_real("Settings", "UseLobby", global.useLobbyServer);
    ini_write_real("Settings", "HostingPort", global.hostingPort);
    ini_write_real("Settings", "IngameMusic", global.ingameMusic);
    ini_write_real("Settings", "PlayerLimit", global.playerLimit);
    ini_write_real("Settings", "Particles", global.particles);
    ini_write_real("Settings", "Gib Level", global.gibLevel);
    ini_write_real("Settings", "Kill Cam", global.killCam);
    ini_write_real("Settings", "Monitor Sync", global.monitorSync);
    ini_write_real("Settings", "Healer Radar", global.medicRadar);
    ini_write_real("Settings", "Show Healer", global.showHealer);
    ini_write_real("Settings", "Show Healing", global.showHealing);
    ini_write_real("Settings", "Show Healthbar", global.showHealthBar);
    ini_write_real("Settings","Timer Position", global.timerPos)
    ini_write_real("Settings","Kill Log Position", global.killLogPos)
    ini_write_real("Settings","KoTH HUD Position", global.kothHudPos)
    ini_write_string("Server", "MapRotation", customMapRotationFile);
    ini_write_real("Server", "Dedicated", global.dedicatedMode);
    ini_write_string("Server", "ServerName", global.serverName);
    ini_write_real("Server", "CapLimit", global.caplimit);
    ini_write_real("Server", "AutoBalance", global.autobalance);
    ini_write_real("Server", "Respawn Time", global.Server_RespawntimeSec);
    ini_write_real("Server", "Total bandwidth limit for map downloads in bytes per second", global.mapdownloadLimitBps);
    ini_write_real("Server", "Time Limit", global.timeLimitMins);
    ini_write_string("Server", "Password", global.serverPassword);
    ini_write_string("Haxxy", "SecretHaxxyKey", global.haxxyKey);
    
    //screw the 0 index we will start with 1
    //map_truefort 
    maps[1] = ini_read_real("Maps", "ctf_truefort", 1);
    //map_2dfort 
    maps[2] = ini_read_real("Maps", "ctf_2dfort", 2);
    //map_conflict 
    maps[3] = ini_read_real("Maps", "ctf_conflict", 3);
    //map_classicwell 
    maps[4] = ini_read_real("Maps", "ctf_classicwell", 4);
    //map_waterway 
    maps[5] = ini_read_real("Maps", "ctf_waterway", 5);
    //map_orange 
    maps[6] = ini_read_real("Maps", "ctf_orange", 6);
    //map_dirtbowl
    maps[7] = ini_read_real("Maps", "cp_dirtbowl", 7);
    //map_egypt
    maps[8] = ini_read_real("Maps", "cp_egypt", 8);
    //arena_montane
    maps[9] = ini_read_real("Maps", "arena_montane", 9);
    //arena_lumberyard
    maps[10] = ini_read_real("Maps", "arena_lumberyard", 10);
    //gen_destroy
    maps[11] = ini_read_real("Maps", "gen_destroy", 11);
    //koth_valley
    maps[12] = ini_read_real("Maps", "koth_valley", 12);
    //koth_corinth
    maps[13] = ini_read_real("Maps", "koth_corinth", 13);
    //koth_harvest
    maps[14] = ini_read_real("Maps", "koth_harvest", 14);
    //dkoth_atalia
    maps[15] = ini_read_real("Maps", "dkoth_atalia", 15);
    //dkoth_sixties
    maps[16] = ini_read_real("Maps", "dkoth_sixties", 16);
    
    //Server respawn time calculator. Converts each second to a frame. (read: multiply by 30 :hehe:)
    if (global.Server_RespawntimeSec == 0)
    {
        global.Server_Respawntime = 1;
    }    
    else
    {
        global.Server_Respawntime = global.Server_RespawntimeSec * 30;    
    }    
    
    // I have to include this, or the client'll complain about an unknown variable.
    global.mapchanging = false;
    
    ini_write_real("Maps", "ctf_truefort", maps[1]);
    ini_write_real("Maps", "ctf_2dfort", maps[2]);
    ini_write_real("Maps", "ctf_conflict", maps[3]);
    ini_write_real("Maps", "ctf_classicwell", maps[4]);
    ini_write_real("Maps", "ctf_waterway", maps[5]);
    ini_write_real("Maps", "ctf_orange", maps[6]);
    ini_write_real("Maps", "cp_dirtbowl", maps[7]);
    ini_write_real("Maps", "cp_egypt", maps[8]);
    ini_write_real("Maps", "arena_montane", maps[9]);
    ini_write_real("Maps", "arena_lumberyard", maps[10]);
    ini_write_real("Maps", "gen_destroy", maps[11]);
    ini_write_real("Maps", "koth_valley", maps[12]);
    ini_write_real("Maps", "koth_corinth", maps[13]);
    ini_write_real("Maps", "koth_harvest", maps[14]);
    ini_write_real("Maps", "dkoth_atalia", maps[15]);
    ini_write_real("Maps", "dkoth_sixties", maps[16]);

    ini_close();
    
    // parse the protocol version UUID for later use
    global.protocolUuid = buffer_create();
    parseUuid(PROTOCOL_UUID, global.protocolUuid);
    
    global.gg2lobbyId = buffer_create();
    parseUuid(GG2_LOBBY_UUID, global.gg2lobbyId);
    
var a, IPRaw, portRaw;
doubleCheck=0;
global.launchMap = "";

    for(a = 1; a <= parameter_count(); a += 1) 
    {
        if (parameter_string(a) == "-dedicated")
        {
            global.dedicatedMode = 1;
        }
        else if (parameter_string(a) == "-server")
        {
            IPRaw = parameter_string(a+1);
            if (doubleCheck == 1)
            {
                doubleCheck = 2;
            }
            else
            {
                doubleCheck = 1;
            }
        }
        else if (parameter_string(a) == "-port")
        {
            portRaw = parameter_string(a+1);
            if (doubleCheck == 1)
            {
                doubleCheck = 2;
            }
            else
            {
                doubleCheck = 1;
            }
        }
        else if (parameter_string(a) == "-map")
        {
            global.launchMap = parameter_string(a+1);
            global.dedicatedMode = 1;
        }
    }
    
    if (doubleCheck == 2)
    {
        global.serverPort = real(portRaw);
        global.serverIP = IPRaw;
        global.isHost = false;
        instance_create(0,0,Client);
    }   
    
    global.customMapdesginated = 0;    
    
    // if the user defined a valid map rotation file, then load from there

    if(customMapRotationFile != "" && file_exists(customMapRotationFile) && global.launchMap == "") {
        global.customMapdesginated = 1;
        var fileHandle, i, mapname;
        fileHandle = file_text_open_read(customMapRotationFile);
        for(i = 1; !file_text_eof(fileHandle); i += 1) {
            mapname = file_text_read_string(fileHandle);
            // remove leading whitespace from the string
            while(string_char_at(mapname, 0) == " " || string_char_at(mapname, 0) == chr(9)) { // while it starts with a space or tab
              mapname = string_delete(mapname, 0, 1); // delete that space or tab
            }
            if(mapname != "" && string_char_at(mapname, 0) != "#") { // if it's not blank and it's not a comment (starting with #)
                ds_list_add(global.map_rotation, mapname);
            }
            file_text_readln(fileHandle);
        }
        file_text_close(fileHandle);
    }
    
     else if (global.launchMap != "") && (global.dedicatedMode == 1)
        {  
        ds_list_add(global.map_rotation, global.launchMap);
        }
    
     else { // else load from the ini file Maps section
        //Set up the map rotation stuff
        var i, sort_list;
        sort_list = ds_list_create();
        for(i=1; i <= 16; i += 1) {
            if(maps[i] != 0) ds_list_add(sort_list, ((100*maps[i])+i));
        }
        ds_list_sort(sort_list, 1);
        
        // translate the numbers back into the names they represent
        for(i=0; i < ds_list_size(sort_list); i += 1) {
            switch(ds_list_find_value(sort_list, i) mod 100) {
                case 1:
                    ds_list_add(global.map_rotation, "ctf_truefort");
                break;
                case 2:
                    ds_list_add(global.map_rotation, "ctf_2dfort");
                break;
                case 3:
                    ds_list_add(global.map_rotation, "ctf_conflict");
                break;
                case 4:
                    ds_list_add(global.map_rotation, "ctf_classicwell");
                break;
                case 5:
                    ds_list_add(global.map_rotation, "ctf_waterway");
                break;
                case 6:
                    ds_list_add(global.map_rotation, "ctf_orange");
                break;
                case 7:
                    ds_list_add(global.map_rotation, "cp_dirtbowl");
                break;
                case 8:
                    ds_list_add(global.map_rotation, "cp_egypt");
                break;
                case 9:
                    ds_list_add(global.map_rotation, "arena_montane");
                break;
                case 10:
                    ds_list_add(global.map_rotation, "arena_lumberyard");
                break;
                case 11:
                    ds_list_add(global.map_rotation, "gen_destroy");
                break;
                case 12:
                    ds_list_add(global.map_rotation, "koth_valley");
                break;
                case 13:
                    ds_list_add(global.map_rotation, "koth_corinth");
                break;
                case 14:
                    ds_list_add(global.map_rotation, "koth_harvest");
                break;
                case 15:
                    ds_list_add(global.map_rotation, "dkoth_atalia");
                break;
                case 16:
                    ds_list_add(global.map_rotation, "dkoth_sixties");
                break;
                    
            }
        }
        ds_list_destroy(sort_list);
    }
    
    window_set_fullscreen(global.fullscreen);
    
    draw_set_font(fnt_gg2);
    cursor_sprite = CrosshairS;
    
    if(!directory_exists(working_directory + "\Maps")) directory_create(working_directory + "\Maps");
    
    instance_create(0, 0, AudioControl);
    instance_create(0, 0, SSControl);
    
    // custom dialog box graphics
    message_background(popupBackgroundB);
    message_button(popupButtonS);
    message_text_font("Century",9,c_white,1);
    message_button_font("Century",9,c_white,1);
    message_input_font("Century",9,c_white,0);
    
    //Key Mapping
    ini_open("controls.gg2");
    global.jump = ini_read_real("Controls", "jump", ord("W"));
    global.down = ini_read_real("Controls", "down", ord("S"));
    global.left = ini_read_real("Controls", "left", ord("A"));
    global.right = ini_read_real("Controls", "right", ord("D"));
    global.attack = ini_read_real("Controls", "attack", MOUSE_LEFT);
    global.special = ini_read_real("Controls", "special", MOUSE_RIGHT);
    global.taunt = ini_read_real("Controls", "taunt", ord("F"));
    global.chat1 = ini_read_real("Controls", "chat1", ord("Z"));
    global.chat2 = ini_read_real("Controls", "chat2", ord("X"));
    global.chat3 = ini_read_real("Controls", "chat3", ord("C"));
    global.medic = ini_read_real("Controls", "medic", ord("E"));
    global.drop = ini_read_real("Controls", "drop", ord("B"));
    global.changeTeam = ini_read_real("Controls", "changeTeam", ord("N"));
    global.changeClass = ini_read_real("Controls", "changeClass", ord("M"));
    global.showScores = ini_read_real("Controls", "showScores", vk_shift);
    ini_close();
    
    calculateMonthAndDay();

    if(global.dedicatedMode == 1) {
        AudioControlToggleMute();
        room_goto_fix(Menu);
    }    
}
