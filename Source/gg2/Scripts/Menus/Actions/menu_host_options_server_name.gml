// HostOptionsController: menu_addedit_text2("Server Name:")
var newName;
newName = string_copy(argument0, 0, 25);
gg2_write_ini("Server", "ServerName", newName);
return newName;
