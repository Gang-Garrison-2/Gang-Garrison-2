// argument0: The name of the map to switch to. Must exist (internal or external) otherwise the game will error out.

global.currentMap = argument0;
var mapRoom;
mapRoom = findInternalMapRoom(global.currentMap);
if (mapRoom)
{
    global.currentMapMD5 = "";
    room_goto_fix(mapRoom);        
}
else if(file_exists("Maps/" + global.currentMap + ".png"))
{
    global.currentMapMD5 = CustomMapGetMapMD5(global.currentMap);
    room_goto_fix(CustomMapRoom);
}
else
{
    show_error("Error:#Map " + global.currentMap + " is not in maps folder, and it is not a valid internal map.#Shutting down.", true);
}
