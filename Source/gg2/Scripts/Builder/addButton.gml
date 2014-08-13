/**
 * Adds a button to the GUI
 * Argument0: Button text
 * Argument1: The code that gets executed when the button is clicked, executes twice for toggles with argument0 as the toggle value
 * [Argument2]: Make the button a toggle
 * [Argument3]: Button is active by default (if it's a toggle)
*/

var map;
map = ds_map_create();
ds_map_add(map, "name", argument0);
ds_map_add(map, "code", argument1);
ds_map_add(map, "toggle", argument2);
ds_map_add(map, "active", argument3);

ds_list_add(global.buttons, map);
