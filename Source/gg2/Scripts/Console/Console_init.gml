// Called in game_init, not sure if this should go there.

global.consoleOpen = 0;// Console is disabled by default, open it by clicking in the in-game menu.
global.consoleLog = ds_list_create();// All text in the console is saved here.
global.commandMap = ds_map_create();// All console commands are here, with the name being the key to the to-be executed string.
global.documentationMap = ds_map_create();// See above, only this gets called when a user enters "help something".

Console_defineCommands();

// Any better ideas for this text?
Console_print("Welcome to the GG2"+string(GAME_VERSION_STRING)+" Console!")
Console_print("If you need help on a specific command, just type 'help command'.")
Console_print("You can get a more general help and a list of most commands by typing just 'help'.")
Console_print("")
Console_print("----------------------------------------------------------------------------------")
Console_print("")
