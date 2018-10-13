// Returns true if the game is successfully initialized, false if there was an error and we should quit.
{
    initCharacterSpritePrefixes();
    initAllHeadPoses();
    initGear();
    
    instance_create(0,0,RoomChangeObserver);
    set_little_endian_global(true);
    if file_exists("game_errors.log") file_delete("game_errors.log");
    if file_exists("last_plugin.log") file_delete("last_plugin.log");
    
    // Delete old left-over files created by the updater
    var backupFilename;
    backupFilename = file_find_first("gg2-old.delete.me.*", 0);
    while(backupFilename != "")
    {
        file_delete(backupFilename);
        backupFilename = file_find_next();
    }
    file_find_close();
    
    var customMapRotationFile, restart;
    restart = false;

    initializeDamageSources();
    
    //import wav files for music
    global.MenuMusic = sound_add(choose("Music/menumusic1.wav","Music/menumusic2.wav","Music/menumusic3.wav","Music/menumusic4.wav","Music/menumusic5.wav","Music/menumusic6.wav"), 1, true);
    global.IngameMusic = sound_add("Music/ingamemusic.wav", 1, true);
    global.FaucetMusic = sound_add("Music/faucetmusic.wav", 1, true);
    if(global.MenuMusic != -1)
        sound_volume(global.MenuMusic, 0.8);
    if(global.IngameMusic != -1)
        sound_volume(global.IngameMusic, 0.8);
    if(global.FaucetMusic != -1)
        sound_volume(global.FaucetMusic, 0.8);
    
    global.sendBuffer = buffer_create();
    global.tempBuffer = buffer_create();
    global.HudCheck = false;
    global.map_rotation = ds_list_create();
    
    global.CustomMapCollisionSprite = -1;

    global.defaultBackground = choose(MenuBackground1, MenuBackground2);
    
    window_set_region_scale(-1, false);
    
    ini_open("gg2.ini");
    global.playerName = ini_read_string("Settings", "PlayerName", "Player");
    global.playerName = string_copy(global.playerName, 0, min(string_length(global.playerName), MAX_PLAYERNAME_LENGTH));
    global.fullscreen = ini_read_real("Settings", "Fullscreen", 0);
    global.useLobbyServer = ini_read_real("Settings", "UseLobby", 1);
    global.hostingPort = ini_read_real("Settings", "HostingPort", 8190);
    global.music = ini_read_real("Settings", "Music", ini_read_real("Settings", "IngameMusic", MUSIC_BOTH));
    global.playerLimit = ini_read_real("Settings", "PlayerLimit", 10);
    
    global.multiClientLimit = ini_read_real("Settings", "MultiClientLimit", 3);
    global.particles =  ini_read_real("Settings", "Particles", PARTICLES_NORMAL);
    global.gibLevel = ini_read_real("Settings", "Gib Level", 3);
    global.killCam = ini_read_real("Settings", "Kill Cam", 1);
    global.monitorSync = ini_read_real("Settings", "Monitor Sync", 0);
    set_synchronization(global.monitorSync);
    global.medicRadar = ini_read_real("Settings", "Healer Radar", 1);
    global.showHealer = ini_read_real("Settings", "Show Healer", 1);
    global.showHealing = ini_read_real("Settings", "Show Healing", 1);
    global.showHealthBar = ini_read_real("Settings", "Show Healthbar", 0);
    global.showTeammateStats = ini_read_real("Settings", "Show Extra Teammate Stats", 0);
    global.serverPluginsPrompt = ini_read_real("Settings", "ServerPluginsPrompt", 1);
    global.restartPrompt = ini_read_real("Settings", "RestartPrompt", 1);
    //user HUD settings
    global.timerPos = ini_read_real("Settings","Timer Position", 0);
    global.killLogPos = ini_read_real("Settings","Kill Log Position", 0);
    global.kothHudPos = ini_read_real("Settings","KoTH HUD Position", 0);
    global.fadeScoreboard = ini_read_real("Settings", "Fade Scoreboard", 1);
    global.clientPassword = "";
    // for admin menu
    customMapRotationFile = ini_read_string("Server", "MapRotation", "");
    global.shuffleRotation = ini_read_real("Server", "ShuffleRotation", 1);
    global.timeLimitMins = max(1, min(255, ini_read_real("Server", "Time Limit", 15)));
    global.serverPassword = ini_read_string("Server", "Password", "");
    global.mapRotationFile = customMapRotationFile;
    global.dedicatedMode = ini_read_real("Server", "Dedicated", 0);
    global.serverName = ini_read_string("Server", "ServerName", "My Server");
    global.welcomeMessage = ini_read_string("Server", "WelcomeMessage", "");
    global.caplimit = max(1, min(255, ini_read_real("Server", "CapLimit", 5)));
    global.caplimitBkup = global.caplimit;
    global.killLimit = max(1, min(65535, ini_read_real("Server", "Deathmatch Kill Limit", 30)));
    global.tdmInvulnerabilitySeconds = max(0, min(3600, ini_read_real("Server", "Team Deathmatch Invulnerability Seconds", 5)));
    global.autobalance = ini_read_real("Server", "AutoBalance",1);
    global.Server_RespawntimeSec = ini_read_real("Server", "Respawn Time", 5);
    global.rewardKey = unhex(ini_read_string("Haxxy", "RewardKey", ""));
    global.rewardId = ini_read_string("Haxxy", "RewardId", "");
    global.mapdownloadLimitBps = ini_read_real("Server", "Total bandwidth limit for map downloads in bytes per second", 50000);
    global.updaterBetaChannel = ini_read_real("General", "UpdaterBetaChannel", isBetaVersion());
    global.attemptPortForward = ini_read_real("Server", "Attempt UPnP Forwarding", 0); 
    global.serverPluginList = ini_read_string("Server", "ServerPluginList", "");
    global.serverPluginsRequired = ini_read_real("Server", "ServerPluginsRequired", 0);
    if (string_length(global.serverPluginList) > 254) {
        show_message("Error: Server plugin list cannot exceed 254 characters");
        return false;
    }
    var CrosshairFilename, CrosshairRemoveBG;
    CrosshairFilename = ini_read_string("Settings", "CrosshairFilename", "");
    CrosshairRemoveBG = ini_read_real("Settings", "CrosshairRemoveBG", 1);
    global.queueJumping = ini_read_real("Settings", "Queued Jumping", 0);
    global.hideSpyGhosts = ini_read_real("Settings", "Hide Spy Ghosts", 0);
    //Hidden setting
    global.forceAudioFix = ini_read_real("Settings", "forceAudioFix", 0);

    global.backgroundHash = ini_read_string("Background", "BackgroundHash", "default");
    global.backgroundTitle = ini_read_string("Background", "BackgroundTitle", "");
    global.backgroundURL = ini_read_string("Background", "BackgroundURL", "");
    global.backgroundShowVersion = ini_read_real("Background", "BackgroundShowVersion", true);
    
    global.resolutionkind = ini_read_real("Settings", "Resolution", 1);
    global.frameratekind = ini_read_real("Settings", "Framerate", 0);
    if(global.frameratekind == 1)
        global.game_fps = 60;
    else
        global.game_fps = 30;
    
    readClasslimitsFromIni();

    //thy playerlimit shalt not exceed 48!
    if (global.playerLimit > 48)
    {
        global.playerLimit = 48;
        if (global.dedicatedMode != 1)
            show_message("Warning: Player Limit cannot exceed 48. It has been set to 48");
    }
    
    global.currentMapArea = 1;
    global.totalMapAreas = 1;
    global.setupTimer = 0;
    global.joinedServerName = "";
    global.serverPluginsInUse = false;
    // Create plugin packet maps
    global.pluginPacketBuffers = ds_map_create();
    global.pluginPacketPlayers = ds_map_create();
        
    ini_write_string("Settings", "PlayerName", global.playerName);
    ini_write_real("Settings", "Fullscreen", global.fullscreen);
    ini_write_real("Settings", "UseLobby", global.useLobbyServer);
    ini_write_real("Settings", "HostingPort", global.hostingPort);
    ini_key_delete("Settings", "IngameMusic");
    ini_write_real("Settings", "Music", global.music);
    ini_write_real("Settings", "PlayerLimit", global.playerLimit);
    ini_write_real("Settings", "MultiClientLimit", global.multiClientLimit);
    ini_write_real("Settings", "Particles", global.particles);
    ini_write_real("Settings", "Gib Level", global.gibLevel);
    ini_write_real("Settings", "Kill Cam", global.killCam);
    ini_write_real("Settings", "Monitor Sync", global.monitorSync);
    ini_write_real("Settings", "Healer Radar", global.medicRadar);
    ini_write_real("Settings", "Show Healer", global.showHealer);
    ini_write_real("Settings", "Show Healing", global.showHealing);
    ini_write_real("Settings", "Show Healthbar", global.showHealthBar);
    ini_write_real("Settings", "Show Extra Teammate Stats", global.showTeammateStats);
    ini_write_real("Settings", "Timer Position", global.timerPos);
    ini_write_real("Settings", "Kill Log Position", global.killLogPos);
    ini_write_real("Settings", "KoTH HUD Position", global.kothHudPos);
    ini_write_real("Settings", "Fade Scoreboard", global.fadeScoreboard);
    ini_write_real("Settings", "ServerPluginsPrompt", global.serverPluginsPrompt);
    ini_write_real("Settings", "RestartPrompt", global.restartPrompt);
    ini_write_string("Server", "MapRotation", customMapRotationFile);
    ini_write_real("Server", "ShuffleRotation", global.shuffleRotation);
    ini_write_real("Server", "Dedicated", global.dedicatedMode);
    ini_write_string("Server", "ServerName", global.serverName);
    ini_write_string("Server", "WelcomeMessage", global.welcomeMessage);
    ini_write_real("Server", "CapLimit", global.caplimit);
    ini_write_real("Server", "Deathmatch Kill Limit", global.killLimit);
    ini_write_real("Server", "Team Deathmatch Invulnerability Seconds", global.tdmInvulnerabilitySeconds);
    ini_write_real("Server", "AutoBalance", global.autobalance);
    ini_write_real("Server", "Respawn Time", global.Server_RespawntimeSec);
    ini_write_real("Server", "Total bandwidth limit for map downloads in bytes per second", global.mapdownloadLimitBps);
    ini_write_real("Server", "Time Limit", global.timeLimitMins);
    ini_write_string("Server", "Password", global.serverPassword);
    ini_write_real("General", "UpdaterBetaChannel", global.updaterBetaChannel);
    ini_write_real("Server", "Attempt UPnP Forwarding", global.attemptPortForward); 
    ini_write_string("Server", "ServerPluginList", global.serverPluginList); 
    ini_write_real("Server", "ServerPluginsRequired", global.serverPluginsRequired); 
    ini_write_string("Settings", "CrosshairFilename", CrosshairFilename);
    ini_write_real("Settings", "CrosshairRemoveBG", CrosshairRemoveBG);
    ini_write_real("Settings", "Queued Jumping", global.queueJumping);
    ini_write_real("Settings", "Hide Spy Ghosts", global.hideSpyGhosts);

    ini_write_string("Background", "BackgroundHash", global.backgroundHash);
    ini_write_string("Background", "BackgroundTitle", global.backgroundTitle);
    ini_write_string("Background", "BackgroundURL", global.backgroundURL);
    ini_write_real("Background", "BackgroundShowVersion", global.backgroundShowVersion);
    
    ini_write_real("Classlimits", "Scout", global.classlimits[CLASS_SCOUT])
    ini_write_real("Classlimits", "Pyro", global.classlimits[CLASS_PYRO])
    ini_write_real("Classlimits", "Soldier", global.classlimits[CLASS_SOLDIER])
    ini_write_real("Classlimits", "Heavy", global.classlimits[CLASS_HEAVY])
    ini_write_real("Classlimits", "Demoman", global.classlimits[CLASS_DEMOMAN])
    ini_write_real("Classlimits", "Medic", global.classlimits[CLASS_MEDIC])
    ini_write_real("Classlimits", "Engineer", global.classlimits[CLASS_ENGINEER])
    ini_write_real("Classlimits", "Spy", global.classlimits[CLASS_SPY])
    ini_write_real("Classlimits", "Sniper", global.classlimits[CLASS_SNIPER])
    ini_write_real("Classlimits", "Quote", global.classlimits[CLASS_QUOTE])

    ini_write_real("Settings", "Resolution", global.resolutionkind);
    ini_write_real("Settings", "Framerate", global.frameratekind);

    rooms_fix_views();
    global.changed_resolution = false;
    
    var iniMapRotation, mapsInDefaultOrderStr, mapsInDefaultOrder, mapIndex, mapName, mapDefaultPriority, mapPriority;
    mapsInDefaultOrderStr = "ctf_truefort,ctf_2dfort,ctf_conflict,ctf_classicwell,ctf_waterway,ctf_orange,cp_dirtbowl,cp_egypt,arena_montane,arena_lumberyard,gen_destroy,koth_valley,koth_corinth,koth_harvest,dkoth_atalia,dkoth_sixties,tdm_mantic,ctf_avanti,koth_gallery,ctf_eiger";
    mapsInDefaultOrder = split(mapsInDefaultOrderStr, ",");
    iniMapRotation = ds_priority_create();

    for(mapIndex = 0; mapIndex < ds_list_size(mapsInDefaultOrder); mapIndex += 1)
    {
        mapName = ds_list_find_value(mapsInDefaultOrder, mapIndex);
        mapDefaultPriority = mapIndex + 1;
        mapPriority = ini_read_real("Maps", mapName, mapDefaultPriority);
        ini_write_real("Maps", mapName, mapPriority);
        if(mapPriority != 0)
            ds_priority_add(iniMapRotation, mapName, mapPriority);
    }

    ds_list_destroy(mapsInDefaultOrder);
    ini_close();
    
    while(!ds_priority_empty(iniMapRotation))
        ds_list_add(global.map_rotation, ds_priority_delete_min(iniMapRotation));
        
    ds_priority_destroy(iniMapRotation);

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
    
    // parse the protocol version UUID for later use
    global.protocolUuid = buffer_create();
    parseUuid(PROTOCOL_UUID, global.protocolUuid);

    global.gg2lobbyId = buffer_create();
    parseUuid(GG2_LOBBY_UUID, global.gg2lobbyId);

    // Create abbreviations array for rewards use
    initRewards()
    
var a, IPRaw, portRaw;
doubleCheck = 0;
global.launchMap = "";

    for(a = 1; a <= parameter_count(); a += 1) 
    {
        if (parameter_string(a) == "-dedicated")
        {
            global.dedicatedMode = 1;
        }
        else if (parameter_string(a) == "-restart")
        {
            restart = true;
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
    
    // if the user defined a valid map rotation file, then override the gg2.ini map rotation and load from there
    if ((global.launchMap != "") and (global.dedicatedMode == 1))
    {
        ds_list_clear(global.map_rotation);
        ds_list_add(global.map_rotation, global.launchMap);
    }
    else if ((customMapRotationFile != "") and file_exists(customMapRotationFile))
    {
        ds_list_clear(global.map_rotation);
        var fileHandle, i, mapname;
        fileHandle = file_text_open_read(customMapRotationFile);
        for(i = 1; !file_text_eof(fileHandle); i += 1) {
            mapname = trim(file_text_read_string(fileHandle));
            if(mapname != "" and string_char_at(mapname, 0) != "#") { // if it's not blank and it's not a comment (starting with #)
                ds_list_add(global.map_rotation, mapname);
            }
            file_text_readln(fileHandle);
        }
        file_text_close(fileHandle);
    }
    
    window_set_fullscreen(global.fullscreen);
    
    global.gg2Font = font_add_sprite(gg2FontS, ord("!"), false, 0);
    global.countFont = font_add_sprite(countFontS, ord("0"), false, 2);
    global.timerFont = font_add_sprite(timerFontS, ord("0"), true, 5);
    draw_set_font(global.gg2Font);
    cursor_sprite = CrosshairS;
    global.dealDamageFunction = ""; // executed after dealDamage, with same args
    
    if(!directory_exists(working_directory + "\Maps")) directory_create(working_directory + "\Maps");
    
    instance_create(0, 0, AudioControl);
    instance_create(0, 0, SSControl);
    
    // custom dialog box graphics
    message_background(popupBackgroundB);
    message_button(popupButtonS);
    message_text_font("Century", 9, c_white, 1);
    message_button_font("Century", 9, c_white, 1);
    message_input_font("Century", 9, c_white, 0);
    
    //Key Mapping
    ini_open("controls.gg2");
    global.jump = ini_read_real("Controls", "jump", ord("W"));
    global.jump2 = ini_read_real("Controls", "jump alt", vk_up);
    global.down = ini_read_real("Controls", "down", ord("S"));
    global.down2 = ini_read_real("Controls", "down alt", vk_down);
    global.left = ini_read_real("Controls", "left", ord("A"));
    global.left2 = ini_read_real("Controls", "left alt", vk_left);
    global.right = ini_read_real("Controls", "right", ord("D"));
    global.right2 = ini_read_real("Controls", "right alt", vk_right);
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
    
    builder_init();

    character_init();
    
    if(!directory_exists(working_directory + "\Plugins")) directory_create(working_directory + "\Plugins");
    loadplugins();
    
    /* Windows 8 is known to crash GM when more than three (?) sounds play at once
     * We'll store the kernel version (Win8 is 6.2, Win7 is 6.1) and check it there.
     ***/
    registry_set_root(1); // HKLM
    global.NTKernelVersion = real(registry_read_string_ext("\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CurrentVersion")); // SIC
    if(!registry_exists_ext("\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CurrentMajorVersionNumber"))
        global.CurrentMajorVersionNumber = -1;
    else
        global.CurrentMajorVersionNumber = registry_read_real_ext("\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CurrentMajorVersionNumber");
    
    globalvar previous_window_x, previous_window_y, previous_window_w;
    previous_window_x = window_get_x();
    previous_window_y = window_get_y();
    previous_window_w = window_get_width();
    
    if (file_exists(CrosshairFilename))
    {
        sprite_replace(CrosshairS,CrosshairFilename,1,CrosshairRemoveBG,false,0,0);
        sprite_set_offset(CrosshairS,sprite_get_width(CrosshairS)/2,sprite_get_height(CrosshairS)/2);
    }
    
    if(global.dedicatedMode == 1) {
        AudioControlToggleMute();
        room_goto_fix(Menu);
    } else if(restart) {
        room_goto_fix(Menu);
    }
    return true;
}
