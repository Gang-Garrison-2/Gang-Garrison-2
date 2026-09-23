// MainMenuController: menu_addlink("Join (manual)")
global.isHost = false;
global.serverIP = get_string("Please enter the IP address or hostname of the server you want to join", "127.0.0.1");
global.serverPort = get_integer("Please enter the port of the server you want to join", 8190);
instance_create(0,0,Client);
Client.returnRoom = Menu;
