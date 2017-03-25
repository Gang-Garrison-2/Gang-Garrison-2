// next map by name = nextMapInRotation()
// Only use from GameServer
var desiredMapName, desiredMapIndex, i, numberOfMaps;
numberOfMaps = ds_list_size(global.map_rotation);

for(i = 1; i <= numberOfMaps; i += 1)
{
    desiredMapIndex = (GameServer.currentMapIndex + i) mod numberOfMaps;
    desiredMapName = ds_list_find_value(global.map_rotation, desiredMapIndex);
    if(findInternalMapName(desiredMapName) != "" or file_exists("Maps/" + desiredMapName + ".png"))
    {
        GameServer.currentMapIndex = desiredMapIndex;
        return desiredMapName;
    }
}

show_error("Error: Invalid rotation: doesn't contain any valid maps. Exiting.", true);
