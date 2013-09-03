// next map by name = nextMapInRotation()
var desiredMapName, desiredMapIndex;
desiredMapIndex = global.currentMapIndex;
do
{
    if(i >= ds_list_size(global.map_rotation))
    {
        show_message("Error: Invalid rotation: doesn't contain any valid maps. Exiting.");
        game_end();
        exit;
    }
    i += 1;
    
    desiredMapIndex += 1;
    if(desiredMapIndex == ds_list_size(global.map_rotation)) 
        desiredMapIndex = 0;
    desiredMapName = ds_list_find_value(global.map_rotation, desiredMapIndex);
} until( internalMapRoom(desiredMapName) or file_exists("Maps/" + desiredMapName + ".png") );

return desiredMapName;

