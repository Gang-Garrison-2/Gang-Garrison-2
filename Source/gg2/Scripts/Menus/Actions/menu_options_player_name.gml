// OptionsController: menu_addedit_text2("Player name:")
var newName;
newName = string_copy(argument0, 0, min(string_length(argument0), MAX_PLAYERNAME_LENGTH));
gg2_write_ini("Settings", "PlayerName", newName);
if(room != Options and newName != oldPlayerName)
{
    write_ubyte(global.serverSocket, PLAYER_CHANGENAME);
    write_ubyte(global.serverSocket, string_length(newName));
    write_string(global.serverSocket, newName);
    socket_send(global.serverSocket);
}
oldPlayerName = newName;
return newName;
