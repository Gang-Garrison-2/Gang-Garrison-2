// HostOptionsController: menu_addedit_text2("Welcome message:")
var newMessage;
newMessage = string_copy(argument0, 0, 255);
gg2_write_ini("Server", "WelcomeMessage", newMessage);
return newMessage;
