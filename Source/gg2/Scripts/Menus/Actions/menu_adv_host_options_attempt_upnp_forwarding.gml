// AdvHostOptionsController: menu_addedit_boolean("Attempt UPnP Forwarding:")
if (argument0 == 1)
    show_message("Warning: UPNP support is currently experimental and enabling it may cause freezing while starting a server, but should cause no freezing ingame")
gg2_write_ini("Server", "Attempt UPnP Forwarding", argument0);
