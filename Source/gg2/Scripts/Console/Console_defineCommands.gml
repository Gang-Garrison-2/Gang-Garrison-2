// This defines all the built-in commands

// input[1] = first argument, input[2] = second, etc...

Console_addCommand("help", "
if input[1] == ''
{
    var key;
    // User didn't ask any specific command, just give the general command list and infos.
    Console_print('GG2'+string(GAME_VERSION_STRING)+' console;');
    Console_print('');
    Console_print('Usage: Type in the wanted command followed by its arguments in this syntax:');
    Console_print('command arg1 arg2 arg3')
    Console_print('');
    Console_print('If an argument contains spaces, please surround it with '+chr(34)+' '+chr(34)+'.');
    Console_print('Some commands require Player IDs, the command listPlayers can show them to you.');
    Console_print('');
    Console_print('The current command list:');
    key = ds_map_find_first(global.commandMap);
    Console_print(key);
    for (i=0; i<ds_map_size(global.commandMap)-1; i+=1)
    {
        key = ds_map_find_next(global.commandMap, key);
        Console_print(key);
    }
    Console_print('')
    Console_print('For more details on each command, enter '+chr(34)+'help commandName'+chr(34)+'.')
    Console_print('----------------------------------------------------------------------------------');
}
else
{
    if ds_map_exists(global.documentationMap, input[1])
    {
        execute_string(ds_map_find_value(global.documentationMap, input[1]));
    }
    else
    {
        Console_print('No documentation could be found for that command.');
    }
}
", ""// Yeah, no doc string for help :/
);


Console_addCommand("kick", "
// Check whether we are the host before anything else
if not global.isHost
{
    Console_print('Only the host can use this command.');
    exit;
}
// Check if the player is even a valid one.
if ds_list_size(global.players)-1 < floor(real(input[1]))// How to check whether input[1] is a number?
{
    Console_print('Invalid player number, please check the correct one with listPlayers.');
    exit;
}
var player;
player = ds_list_find_value(global.players, floor(real(input[1])))
if player != -1 and floor(real(input[1])) > 0
{
    with player
    {
        socket_destroy_abortive(socket);
        socket = -1;
    }
    Console_print(player.name+' has been kicked successfully.');
}
else
{
    if input[1] == '0'
    {
        Console_print('The host cannot be kicked.');
    }
    else
    {
        Console_print('Could not find a player with that ID.');
    }
}
", "
Console_print('Syntax: kick playerID')
Console_print('Use: Kicks the designed player from the game, disconnecting him but not banning him.')
Console_print('Warning: Attempting to kick the host will have no effect.')");


Console_addCommand("listPlayers", "
var redteam, blueteam, specteam, player;
redteam = ds_list_create();
blueteam = ds_list_create();
specteam = ds_list_create();

with Player
{
    if team == TEAM_RED
    {
        ds_list_add(redteam, id);
    }
    else if team == TEAM_BLUE
    {
        ds_list_add(blueteam, id);
    }
    else
    {
        ds_list_add(specteam, id);
    }
}

Console_print('')
Console_print('Current Player list:')

for (i=0; i<ds_list_size(redteam); i+=1)
{
    player = ds_list_find_value(redteam, i);
    Console_print('/:/'+COLOR_RED+player.name+':    ID='+string(ds_list_find_index(global.players, player.id)));
}
for (i=0; i<ds_list_size(blueteam); i+=1)
{
    player = ds_list_find_value(blueteam, i);
    Console_print('/:/'+COLOR_BLUE+player.name+':    ID='+string(ds_list_find_index(global.players, player.id)));
}
for (i=0; i<ds_list_size(specteam); i+=1)
{
    player = ds_list_find_value(specteam, i);
    Console_print('/:/'+COLOR_GREEN+player.name+':    ID='+string(ds_list_find_index(global.players, player.id)));
}
", "
Console_print('Syntax: listPlayers')
Console_print('Use: Prints a color-coded list of the IDs of all the players in the game.')
Console_print('These IDs are necessary for anything requiring a specific player, like kicking.')");


Console_addCommand("clearScreen", "
with Console
{
    clearScreenTimer = 36// Makes text zoom up instead of just disappearing
}
", "
Console_print('Syntax: clearScreen')
Console_print('Use: Clears the console')");


Console_addCommand("broadcast", "
if not global.isHost
{
    Console_print('Only the host can use this command.');
    exit;
}

if input[1] != ''
{
    var message;
    message = input[1];
    if string_copy(message, 0, 1) == chr(34)
    {
        // Cut off starting and ending quotes
        message = string_copy(message, 1, string_length(message)-2);
    }

    // Send it to everyone
    write_ubyte(global.eventBuffer, MESSAGE_STRING);
    write_ubyte(global.eventBuffer, string_length(message));
    write_string(global.eventBuffer, message);
    // Show it for the host as well
    var notice;
    with NoticeO instance_destroy();
    notice = instance_create(0, 0, NoticeO);
    notice.notice = NOTICE_CUSTOM;
    notice.message = message;
}
", "
Console_print('Syntax: broadcast '+chr(34)+'message to be sent'+chr(34));
Console_print('Use: Makes all clients receive a notification bearing the message');
Console_print('Warning: If spaces are in the message, remember to surround the message in quotes!');
");


Console_addCommand("execute", "
execute_string(input[1]);
", "
Console_print('Syntax: execute '+chr(34)+'<code>'+chr(34));
Console_print('Use: Executes the given code immediately.');
Console_print('Warning: Can cause crashes, use at own responsability!');
");
