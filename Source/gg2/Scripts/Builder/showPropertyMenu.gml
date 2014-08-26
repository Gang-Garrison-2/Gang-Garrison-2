/** Allows the user to edit an entities properties
 * Argument0: The selected entity.
 * Argument1: A map with properties.
 * Argument2: A map to add the changed properties to.
*/

if (ds_map_size(argument1) == 0) return false;

var key, menu, res, keys, i, new, old, exists, _x, _y;
_x = window_get_x() + mouse_x;
_y = window_get_y() + mouse_y;

do {
    menu = "";
    i = 0;
    for(key=ds_map_find_first(argument1); is_string(key); key=ds_map_find_next(argument1, key)) {
        // Skip scales, they're set by the editor itself.
        if (key == "xscale" || key == "yscale") continue;
        
        menu += key + ": ";
        if (is_string(ds_map_find_value(argument2, key))) menu += ds_map_find_value(argument2, key) + "|";
        else menu += ds_map_find_value(argument1, key) + "|";
        keys[i] = key;
        i += 1;
    }
    if (i == 0) return false;
    else if (i == 1) res = 0;
    else {
        // If there's more than 1 property, show a list of them
        menu = string_copy(menu, 1, string_length(menu));
        res = show_menu_pos(_x, _y, menu, -1);
    }
    if (res != -1) {
        old = ds_map_find_value(argument2, keys[res]);
        exists = true;
        if (!is_string(old)) {
            old = ds_map_find_value(argument1, keys[res]);
            exists = false;
        }
        
        if (old == "true") {
            if (exists) ds_map_replace(argument2, keys[res], "false");
            else ds_map_add(argument2, keys[res], "false");
        } else if (old == "false") {
            if (exists) ds_map_replace(argument2, keys[res], "true");
            else ds_map_add(argument2, keys[res], "true");
        } else {
            new = get_string("New value for " + keys[res] + ":", old);
            if (exists) ds_map_replace(argument2, keys[res], new);
            else ds_map_add(argument2, keys[res], new);
        }
    }
} until(res == -1 || i <= 1);
