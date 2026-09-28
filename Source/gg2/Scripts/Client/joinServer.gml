// Connects to global.serverIP:global.serverPort from the menus. A player still using the
// default name is first asked to choose one; cancelling keeps the default.
// argument0 - the room to return to when the connection ends

var returnRoom, newName;
returnRoom = argument0;

if (global.playerName == "Player" and !global.namePromptShown)
{
    newName = get_string("Enter your player name:", "");
    newName = string_copy(newName, 0, min(string_length(newName), MAX_PLAYERNAME_LENGTH));
    // Cancelling and leaving the name blank both come back empty, and keep the default
    if (string_replace_all(newName, " ", "") != "")
    {
        global.playerName = newName;
        gg2_write_ini("Settings", "PlayerName", newName);
    }
    global.namePromptShown = true;
}

global.isHost = false;
if (instance_exists(Client))
{   // We can't _actually_ destroy and recreate the Client here, because destroying it will cause a room change and that will cause the Create event not to run... Yay, GM!
    with (Client)
    {
        event_perform(ev_destroy, 0);
        ClientCreate();
    }
}
else
{
    instance_create(0, 0, Client);
}
Client.returnRoom = returnRoom;
