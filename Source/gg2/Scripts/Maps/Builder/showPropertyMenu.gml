/** Allows the user to edit an entities properties
 * Argument0: A map with properties.
 * Argument1: A map to add the changed properties to.
 * [Argument2]: Allow adding new properties.
*/

if (ds_map_size(argument0) == 0) return false;

var key, menu, res, keys, i, new, old, exists, _x, _y, newPropIdx;
_x = window_get_x() + mouse_x;
_y = window_get_y() + mouse_y;
newPropIdx = -1;

do {
    menu = "";
    i = 0;
    for(key=ds_map_find_first(argument0); is_string(key); key=ds_map_find_next(argument0, key)) {
        // Skip scales and the type, they're set by the editor itself.
        if (key == "type" || key == "xscale" || key == "yscale") continue;
        
        menu += key + ": ";
        if (is_string(ds_map_find_value(argument1, key))) menu += ds_map_find_value(argument1, key) + "|";
        else menu += ds_map_find_value(argument0, key) + "|";
        keys[i] = key;
        i += 1;
    }
    if (argument2 > 0) {
        menu += "Add new property|";
        newPropIdx = i;
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
        if (res == newPropIdx) {
            var prop;
            prop = get_string("New property:", "");
            if (prop != "") {
                if (is_string(ds_map_find_value(argument1, prop)))
                    show_message("This property already exists, edit it instead.");
                else
                    ds_map_add(argument0, prop, get_string("Value for " + prop + ":", ""));
            }            
        } else {
            old = ds_map_find_value(argument1, keys[res]);
            exists = true;
            if (!is_string(old)) {
                old = ds_map_find_value(argument0, keys[res]);
                exists = false;
            }
            
            if (old == "true") {
                if (exists) ds_map_replace(argument1, keys[res], "false");
                else ds_map_add(argument1, keys[res], "false");
            } else if (old == "false") {
                if (exists) ds_map_replace(argument1, keys[res], "true");
                else ds_map_add(argument1, keys[res], "true");
            } else {
                new = get_string("New value for " + keys[res] + ":", old);
                if (exists) ds_map_replace(argument1, keys[res], new);
                else ds_map_add(argument1, keys[res], new);
            }
        }
    }
} until(res == -1 || i <= 1);
