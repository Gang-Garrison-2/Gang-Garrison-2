/** Allows the user to edit an entities properties
 * Argument0: A map with properties.
 * Argument1: A map to add the changed properties to.
 * [Argument2]: Allow adding new properties.
*/

if (ds_map_size(argument0) == 0)
    return false;

var key, menu, res, keys, i, newPropValue, oldPropValue, exists, _x, _y, newPropIdx, fullName;
_x = window_mouse_get_x() + window_get_x();
_y = window_mouse_get_y() + window_get_y();
newPropIdx = -1;

do
{
    newPropValue = "";
    menu = "";
    i = 0;
    for(key=ds_map_find_first(argument0); is_string(key); key=ds_map_find_next(argument0, key))
    {
        // Skip scales and the type, they're set by the editor itself.
        if (key == "type" || key == "xscale" || key == "yscale") continue;
        
        menu += key + ": ";
        if (is_string(ds_map_find_value(argument1, key))) fullName = ds_map_find_value(argument1, key);
        else fullName = ds_map_find_value(argument0, key);
        menu += string_copy(fullName, 1, 50) + "|";
        
        keys[i] = key;
        i += 1;
    }
    if (argument2 > 0)
    {
        menu += "Add new property|";
        newPropIdx = i;
        i += 1;
    }
    
    if (i == 0)
        return false;
    else if (i == 1)
        res = 0;
    else
    {
        // If there's more than 1 property, show a list of them
        menu = string_copy(menu, 1, string_length(menu));
        res = show_menu_pos(_x, _y, menu, -1);
    }
    if (res != -1)
    {
        if (res == newPropIdx)
        {
            var prop;
            prop = get_string("New property:", "");
            if (prop != "")
            {
                if (is_string(ds_map_find_value(argument1, prop)))
                {
                    show_message("This property already exists, edit it instead.");
                    continue;
                }
                else
                {
                    newPropValue = get_string("Value for " + prop + ":", "")
                    ds_map_add(argument0, prop, newPropValue);
                }
            }            
        }
        else
        {
            prop = keys[res];
            oldPropValue = ds_map_find_value(argument1, prop);
            exists = true;
            if (!is_string(oldPropValue))
            {
                oldPropValue = ds_map_find_value(argument0, prop);
                exists = false;
            }
            
            // Toggle boolean values
            if (oldPropValue == "true")
            {
                if (exists)
                    ds_map_replace(argument1, prop, "false");
                else
                    ds_map_add(argument1, prop, "false");
            }
            else if (oldPropValue == "false")
            {
                if (exists)
                    ds_map_replace(argument1, prop, "true");
                else
                    ds_map_add(argument1, prop, "true");
            }
            else
            {
                newPropValue = get_string("New value for " + prop + ":", oldPropValue);                    
                if (exists)
                    ds_map_replace(argument1, prop, newPropValue);
                else
                    ds_map_add(argument1, prop, newPropValue);
            }
        }
    }
    else {
        newPropValue = " ";
    }

    // Destroy de property if the contents are empty
    if (argument2 > 0 && newPropValue == "")
    {
        ds_map_delete(argument1, prop);
        i -= 1;
    }     
} until(res == -1 || i <= 1);
