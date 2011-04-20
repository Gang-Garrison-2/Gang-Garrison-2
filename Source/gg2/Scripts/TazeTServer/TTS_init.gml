/*
Initializes TazeTServer
*/
global.TTSCommandNames = ds_list_create();
global.TTSCommandScripts = ds_list_create();
global.TTSConsoleLog = ds_list_create();
global.TTSConsoleCmdLog = ds_list_create();
global.TTSRotationFile = argument0;
global.TTSChangeNameFrom = "";

// Map of class limit numbers to class IDs
global.TTSClassLimitsMap[0] = CLASS_QUOTE;
global.TTSClassLimitsMap[1] = CLASS_SCOUT;
global.TTSClassLimitsMap[2] = CLASS_PYRO;
global.TTSClassLimitsMap[3] = CLASS_SOLDIER;
global.TTSClassLimitsMap[4] = CLASS_HEAVY;
global.TTSClassLimitsMap[5] = CLASS_DEMOMAN;
global.TTSClassLimitsMap[6] = CLASS_MEDIC;
global.TTSClassLimitsMap[7] = CLASS_ENGINEER;
global.TTSClassLimitsMap[8] = CLASS_SPY;
global.TTSClassLimitsMap[9] = CLASS_SNIPER;

// Load class limits
ini_open("tts.ini");
global.TTSClassLimits[global.TTSClassLimitsMap[0]] = ini_read_real("Classlimits","Secret",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[1]] = ini_read_real("Classlimits","Runner",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[2]] = ini_read_real("Classlimits","Firebug",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[3]] = ini_read_real("Classlimits","Rocketman",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[4]] = ini_read_real("Classlimits","Overweight",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[5]] = ini_read_real("Classlimits","Detonator",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[6]] = ini_read_real("Classlimits","Healer",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[7]] = ini_read_real("Classlimits","Constructor",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[8]] = ini_read_real("Classlimits","Infiltrator",-1);
global.TTSClassLimits[global.TTSClassLimitsMap[9]] = ini_read_real("Classlimits","Rifleman",-1);
ini_write_real("Classlimits","Secret",global.TTSClassLimits[global.TTSClassLimitsMap[0]]);
ini_write_real("Classlimits","Runner",global.TTSClassLimits[global.TTSClassLimitsMap[1]]);
ini_write_real("Classlimits","Firebug",global.TTSClassLimits[global.TTSClassLimitsMap[2]]);
ini_write_real("Classlimits","Rocketman",global.TTSClassLimits[global.TTSClassLimitsMap[3]]);
ini_write_real("Classlimits","Overweight",global.TTSClassLimits[global.TTSClassLimitsMap[4]]);
ini_write_real("Classlimits","Detonator",global.TTSClassLimits[global.TTSClassLimitsMap[5]]);
ini_write_real("Classlimits","Healer",global.TTSClassLimits[global.TTSClassLimitsMap[6]]);
ini_write_real("Classlimits","Constructor",global.TTSClassLimits[global.TTSClassLimitsMap[7]]);
ini_write_real("Classlimits","Infiltrator",global.TTSClassLimits[global.TTSClassLimitsMap[8]]);
ini_write_real("Classlimits","Rifleman",global.TTSClassLimits[global.TTSClassLimitsMap[9]]);
ini_close();

// Add built-in commands
TTS_addcommand("kick","
    var found, nameneeded;
    nameneeded = argument0;
    found = false;
    with (Player) {
        if (string_lower(name)==string_lower(nameneeded)) {
            kicked = true;
            TTS_writetoconsole('Kicked: '+name);
            found = true;
        }
    }
    if (!found) {
        TTS_writetoconsole('Could not find: '+argument0);
    }
");

TTS_addcommand("endround","
    TTS_writetoconsole('Round ended');
    global.currentMapIndex += 1;
    global.currentMapArea = 1;
    if (global.currentMapIndex == ds_list_size(global.map_rotation)) 
    {
        global.currentMapIndex = 0;
    }
    global.nextMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
    TTS_runcommand('changemap',global.nextMap);
");

TTS_addcommand("changemap","
    global.winners = TEAM_SPECTATOR;
    global.mapchanging = 1;
    global.nextMap = argument0;
    GameServer.impendingMapChange = 300;
    write_ubyte(global.sendBuffer, MAP_END);
    write_ubyte(global.sendBuffer, string_length(global.nextMap));
    write_string(global.sendBuffer, global.nextMap);
    write_ubyte(global.sendBuffer, global.winners);
    write_ubyte(global.sendBuffer, global.currentMapArea);
    
    if !instance_exists(ScoreTableController) instance_create(0,0,ScoreTableController);
    instance_create(0,0,WinBanner);
    
    TTS_writetoconsole('Changing map to: '+argument0);
");

TTS_addcommand("autobalance","
    with (Server) {
        ServerBalanceTeams(42);
    }
    TTS_writetoconsole('Autobalance forced');
");

TTS_addcommand("setclasslimit","
    var class, limit;
    class = real(string_copy(argument0,0,string_pos(' ',argument0)-1));
    limit = real(string_copy(argument0,string_pos(' ',argument0)+1,string_length(argument0)-string_pos(' ',argument0)));
    if (class >= 0 && class <= 9) {
        global.TTSClassLimits[global.TTSClassLimitsMap[class]] = limit;
        if (limit == -1) {
            TTS_writetoconsole('Class limit disabled for class '+string(class));
        }else{
            TTS_writetoconsole('Limited class '+string(class)+' to '+string(limit));
        }
        TTS_saveclasslimits();
    }else{
        TTS_writetoconsole('Invalid class number: '+string(class));
    }
");

TTS_addcommand("listclasslimits","
    var list, i;
    list = '';
    for (i = 0; i < 10; i+=1) {
        list += string(i) + ': ' + string(global.TTSClassLimits[global.TTSClassLimitsMap[i]]) + ';';
    }
    TTS_writetoconsole('Current class limits:');
    TTS_writetoconsole(list);
");

TTS_addcommand("reloadrotation","
    if(global.TTSRotationFile != '' && file_exists(global.TTSRotationFile) && global.launchMap == '') {
        global.customMapdesginated = 1;
        var fileHandle, i, mapname;
        fileHandle = file_text_open_read(global.TTSRotationFile);
        for(i = 1; !file_text_eof(fileHandle); i += 1) {
            mapname = file_text_read_string(fileHandle);
            // remove leading whitespace from the string
            while(string_char_at(mapname, 0) == ' ' || string_char_at(mapname, 0) == chr(9)) { // while it starts with a space or tab
              mapname = string_delete(mapname, 0, 1); // delete that space or tab
            }
            if(mapname != '' && string_char_at(mapname, 0) != '#') { // if it's not blank and it's not a comment (starting with #)
                ds_list_add(global.map_rotation, mapname);
            }
            file_text_readln(fileHandle);
        }
        file_text_close(fileHandle);
        TTS_writetoconsole('Reloaded rotation from '+global.TTSRotationFile);
    }else{
        TTS_writetoconsole('Error: No rotation file set/found');
    }
");

TTS_addcommand("changename","
    var found, foundname;
    found = false;
    foundname = '';
    with (Player) {
        if (string_lower(name) == string_lower(argument0)) {
            found = true;
            foundname = name;
        }
    }
    if (found) {
        TTS_writetoconsole('Selected: '+foundname);
        TTS_writetoconsole('Now type changenameto newname');
        global.TTSChangeNameFrom = foundname;
    }else{
        TTS_writetoconsole('Could not find: '+argument0);
    }
");

TTS_addcommand("changenameto","
    if (global.TTSChangeNameFrom != '') {
        var newname;
        newname = argument0;
        with (Player) {
            if (string_lower(name) == string_lower(global.TTSChangeNameFrom)) {
                name = newname;
                write_ubyte(global.eventBuffer, PLAYER_CHANGENAME);
                write_ubyte(global.eventBuffer, ds_list_find_index(global.players,id));
                write_ubyte(global.eventBuffer, string_length(name));
                write_string(global.eventBuffer, name);
            }
        }
        global.TTSChangeNameFrom = '';
        TTS_writetoconsole('Changed name to: '+newname);
    }else{
        TTS_writetoconsole('You need to have selected a player with changename');
    }
");

TTS_addcommand("loadvinplugin","
    if (file_exists('Plugins/'+argument0+'.txt')){
        TTS_writetoconsole('Loading Vindicator`s mod (compatible) plugin '+argument0+'...');
        with (instance_create(0,0,PluginSandbox)) {
            execute_file('Plugins/'+argument0+'.txt');
            instance_destroy();
        }
    }else{
        TTS_writetoconsole('Could not find plugin: '+argument0);
    }
");

// Load Plugins
var plugin, first;
first = true;
    
TTS_writetoconsole("Loading plugins...");
while (true) {
    if (first == true){
        plugin = file_find_first("Plugins/*.gml",0);
        first = false;
    }else{
        plugin = file_find_next();
    }
    if (plugin != "") {
        TTS_writetoconsole("Loading plugin "+plugin+"...");
        with (instance_create(0,0,PluginSandbox)) {
            execute_file("Plugins/"+plugin,"Plugins/");
            instance_destroy();
        }
    }else if (first == true){
        TTS_writetoconsole("No plugins found.");
        break;
    }else{
        TTS_writetoconsole("All plugins loaded.");
        break;
    }
}
