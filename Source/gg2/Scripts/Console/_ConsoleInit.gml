/*
Initializes Console
*/
global.ConsoleCommandNames = ds_list_create();
global.ConsoleCommandScripts = ds_list_create();
global.ConsoleCommandDocs = ds_list_create();
global.ConsoleLog = ds_list_create();
global.ConsoleCmdLog = ds_list_create();
global.ConsoleWindowX = 395;
global.ConsoleWindowY = 487;
global.ConsoleWidth = 389;

// Add built-in commands

/*
help command follows Standard Console API v1 spec
http://www.ganggarrison.com/forums/index.php?topic=33394

From the spec:

help
- Called without any arguments, prints a list of commands. If a command name is
  specified, prints the help string for the command, which was given with
  ConsoleAddCommand(). Any # characters should NOT display as new lines.
*/
ConsoleAddCommand("help","
    var i;
    // no arguments, display list
    if (string_length(argument0) == 0) {
        var list;
        
        list = '';
        
        for (i = 0; i < ds_list_size(global.ConsoleCommandNames); i+=1) {
            list = list + ds_list_find_value(global.ConsoleCommandNames, i);
            if (i != ds_list_size(global.ConsoleCommandNames) - 1) {
                list = list + ', ';
            }
        }

        ConsolePrint('The following commands are available. To get help on any of them, use help <command name>:');
        ConsolePrint(list);
    // display help for command
    } else {
        i = ds_list_find_index(global.ConsoleCommandNames, argument0);
        if (i != -1) {
            ConsolePrint('Help for command ' + argument0 + ':');
            ConsolePrint(ds_list_find_value(global.ConsoleCommandDocs, i));
        } else {
            ConsolePrint('There is no command named ' + argument0);
        }
    }
", "help [command name] - without a command name specified, lists available commands. With a command name specified, displays its help info.");

ConsoleAddCommand("kick","
    if (!global.isHost) {
        ConsolePrint('You can only use this command when hosting');
        exit;
    }

    var found, nameneeded;
    nameneeded = argument0;
    found = false;
    with (Player) {
        if (string_lower(name) == string_lower(nameneeded) && id != global.myself) {
            kicked = true;
            ConsolePrint('Kicked: ' + name);
            found = true;
        }
    }
    if (!found) {
        ConsolePrint('Could not find: ' + argument0);
    }
", "kick <player name> - kicks player with given name");

ConsoleAddCommand("endround","
    if (!global.isHost) {
        ConsolePrint('You can only use this command when hosting');
        exit;
    }

    ConsolePrint('Round ended');
    global.currentMapIndex += 1;
    global.currentMapArea = 1;
    if (global.currentMapIndex == ds_list_size(global.map_rotation)) 
    {
        global.currentMapIndex = 0;
    }
    global.nextMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
    ConsoleRunCommand('changemap', global.nextMap);
", "endround - ends the round immediately");

ConsoleAddCommand("changemap","
    if (!global.isHost) {
        ConsolePrint('You can only use this command when hosting');
        exit;
    }

    if(!file_exists('Maps/' + argument0 + '.png') && !gotoInternalMapRoom(argument0, true)) {
        ConsolePrint('There is no map named: ' + argument0);
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
    
    ConsolePrint('Changing map to: ' + argument0);
", "changemap <mapname> - changes map to the one specified");

ConsoleAddCommand("broadcast", "
    if (!global.isHost) {
        ConsolePrint('You can only use this command when hosting');
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
", "broadcast <message> - broadcasts message to all players");

ConsoleAddCommand("cls","
    ConsoleClear();
", "cls - clears the console");

ConsoleAddCommand("exec","
    execute_string(argument0);
", "exec <gml code> - runs specified code (warning: bad code could hang up or crash server)");

ConsoleAddCommand("eval","
    ConsolePrint(string(execute_string('return (' + argument0 + ');')));
", "eval <gml code> - evaluates specified expression and prints result(warning: bad code could hang up or crash server)");


ConsoleAddCommand("get","
    var name;

    name = argument0;

    if(variable_global_exists(name)) {
        ConsolePrint(name + ' = ' + string(variable_global_get(name)));
    } else {
        ConsolePrint('There is no global variable named ' + name + '.');
    }
", "get <variable> - gets the value of a global variable");

ConsoleAddCommand("set","
    var name, value, pos;
    
    pos = string_pos(' ', argument0);
    name = string_copy(argument0, 0, pos - 1);
    value = string_copy(argument0, pos + 1, string_length(argument0) - pos);
    
    if(variable_global_exists(name)) {
        if (is_real(variable_global_get(name))) {
            if (!is_real(
            value = real(value);
        }
        variable_global_set(name, value);
        ConsolePrint(name + ' => ' + value);
    } else {
        ConsolePrint('There is no global variable named ' + name + '.');
    }
", "set <variable> - sets the value of a global variable using its existing type, casting as necessary. (warning: changing wrong variable could hang up or crash server)");
