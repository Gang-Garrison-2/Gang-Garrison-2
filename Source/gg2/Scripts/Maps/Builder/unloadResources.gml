/** 
 * Unloads all resources from the global.resources map and clears it.
*/

var resource;
for(resource=ds_map_find_first(global.resources); is_string(resource); resource = ds_map_find_next(global.resources, resource))
{
    if (string_copy(resource,1, 3) == "bg_")
        background_delete(ds_map_find_value(global.resources, resource));
    else
        sprite_delete(ds_map_find_value(global.resources, resource));
}

ds_map_clear(global.resources);
