// LobbyNameController: menu_addedit_text2("Player name:")
var newName;
newName = string_copy(argument0, 0, min(string_length(argument0), MAX_PLAYERNAME_LENGTH));
gg2_write_ini("Settings", "PlayerName", newName);
oldPlayerName = newName;
return newName;
