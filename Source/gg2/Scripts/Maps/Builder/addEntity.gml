/**
 * Adds an entity button to the GUI
 * Argument0: The name
 * Argument1: The gamemodes that this entity can be used on (uses bitmasks to select multiple gamemodes)
 * Argument2: A ggon string with all properties that can be editted.
 * Argument3: The object that gets created ingame.
 * Argument4: The sprite of the entity.
 * Argument5: The image index of the entity sprite.
 * Argument6: The sprite of the button.
 * Argument7: The image index of the button sprite.
 * [Argument8]: Tooltip
 * Returns: An identifier for the entity button
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
ds_map_add(map, "object", argument3);
ds_map_add(map, "entity_sprite", argument4);
ds_map_add(map, "entity_image", argument5);
ds_map_add(map, "button_sprite", argument6);
ds_map_add(map, "button_image", argument7);
ds_map_add(map, "tooltip", argument8);
ds_map_add(map, "properties", ggon_decode(argument2));

ds_list_add(global.entityData, map);

return index;
