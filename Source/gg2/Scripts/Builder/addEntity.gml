/**
 * Adds an entity button to the GUI
 * Argument0: The name
 * Argument1: The gamemodes that this entity can be used on (uses bitmasks to select multiple gamemodes)
 * Argument2: The object that gets created ingame. If it's a child of 'MultiEntity' it will also run it's event_user(0) with the variable 'name' as the entityname.
 * Argument3: The sprite of the entity
 * Argument4: The image index of the entity sprite
 * Argument5: The sprite of the button
 * Argument6: The image index of the button sprite
 * [Argument7]: Tooltip
 * Returns: And identifier for the entity button
*/

var index, map;

// Prevent dupes
index = ds_list_find_index(global.entities, argument0);
if (index != -1) {
    if (ds_map_find_value(ds_list_find_value(global.entityData, index), "gamemode") == argument1) return index;
}

index = ds_list_size(global.entities);
ds_list_add(global.entities, argument0);

map = ds_map_create();
ds_map_add(map, "gamemode", argument1);
ds_map_add(map, "object", argument2);
ds_map_add(map, "entity_sprite", argument3);
ds_map_add(map, "entity_image", argument4);
ds_map_add(map, "button_sprite", argument5);
ds_map_add(map, "button_image", argument6);
ds_map_add(map, "tooltip", argument7);

ds_list_add(global.entityData, map);

return index;
