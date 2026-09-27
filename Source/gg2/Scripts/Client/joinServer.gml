// Connects to global.serverIP:global.serverPort from the menus.
// argument0 - the room to return to when the connection ends

var returnRoom;
returnRoom = argument0;

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
