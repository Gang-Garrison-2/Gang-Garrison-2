/*
Initializes Console
*/
global.ConsoleCommandNames = ds_list_create();
global.ConsoleCommandScripts = ds_list_create();
global.ConsoleLog = ds_list_create();
global.ConsoleCmdLog = ds_list_create();

// Add built-in commands
ConsoleAddCommand("help","
    ConsoleWrite('Type a command and press enter to run it. Press ESC or Enter to close console.');
    ConsoleWrite('1. kick <player name> - kicks player with given name');
    ConsoleWrite('2. endround - ends the round immediately');
    ConsoleWrite('3. changemap <mapname> - changes map to the one specified');
    ConsoleWrite('4. broadcast <message> - broadcasts message to all players');
    ConsoleWrite('5. cls - clears the console');
    ConsoleWrite('6. exec <gml code> - runs specified code (warning: bad code could hang up or crash server)');
");

ConsoleAddCommand("kick","
    if (!global.isHost) {
        ConsoleWrite('You can only use this command when hosting');
        exit;
    }

    var found, nameneeded;
    nameneeded = argument0;
    found = false;
    with (Player) {
        if (string_lower(name) == string_lower(nameneeded) && id != global.myself) {
            kicked = true;
            ConsoleWrite('Kicked: ' + name);
            found = true;
        }
    }
    if (!found) {
        ConsoleWrite('Could not find: ' + argument0);
    }
");

ConsoleAddCommand("endround","
    if (!global.isHost) {
        ConsoleWrite('You can only use this command when hosting');
        exit;
    }

    ConsoleWrite('Round ended');
    global.currentMapIndex += 1;
    global.currentMapArea = 1;
    if (global.currentMapIndex == ds_list_size(global.map_rotation)) 
    {
        global.currentMapIndex = 0;
    }
    global.nextMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
    ConsoleRunCommand('changemap', global.nextMap);
");

ConsoleAddCommand("changemap","
    if (!global.isHost) {
        ConsoleWrite('You can only use this command when hosting');
        exit;
    }

    global.winners = TEAM_SPECTATOR;
    global.mapchanging = 1;
    global.nextMap = argument0;
    GameServer.impendingMapChange = 300;
    write_ubyte(global.sendBuffer, MAP_END);
    write_ubyte(global.sendBuffer, string_length(global.nextMap));
    write_string(global.sendBuffer, global.nextMap);
    write_ubyte(global.sendBuffer, global.winners);
    write_ubyte(global.sendBuffer, global.currentMapArea);
    
    if !instance_exists(ScoreTableController) instance_create(0, 0, ScoreTableController);
    instance_create(0,0,WinBanner);
    
    ConsoleWrite('Changing map to: ' + argument0);
");

ConsoleAddCommand("broadcast", "
    if (!global.isHost) {
        ConsoleWrite('You can only use this command when hosting');
        exit;
    }

    var msg;
    msg = string_copy(argument0, 0, 255);

    // Send it to everyone
    write_ubyte(global.eventBuffer, MESSAGE_STRING);
    write_ubyte(global.eventBuffer, string_length(msg));
    write_string(global.eventBuffer, msg);

    // Show it for the host as well
    var notice;
    with NoticeO instance_destroy();
    notice = instance_create(0, 0, NoticeO);
    notice.notice = NOTICE_CUSTOM;
    notice.message = msg;
");

ConsoleAddCommand("cls","
    ConsoleClear();
");

ConsoleAddCommand("exec","
    execute_string(argument0);
");
