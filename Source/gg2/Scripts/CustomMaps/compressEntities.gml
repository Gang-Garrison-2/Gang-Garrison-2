//If we've reached this stage, then we are good to go. Let's start the entity creation!
var ret;
ret = "{ENTITIES}" + chr(10);

// Compress using GGON
var map, submap, list, key;
list = ds_list_create();
with(LevelEntity) {
    if (data == -1) {
        submap = ds_map_create();
        ds_map_add(submap, "type", type);
        ds_map_add(submap, "x", string(x));
        ds_map_add(submap, "y", string(y));
        if (image_xscale != 1) ds_map_add(submap, "xscale", string(image_xscale)); 
        if (image_yscale != 1) ds_map_add(submap, "yscale", string(image_yscale));
        
        // Copy extra properties
        if (properties != -1) ggon_duplicate_map(properties, submap);
        ds_list_add(list, submap);
    } else {
        // This is a precompiled enitity (when loading a compiled map for example)
        ds_list_add(list, data);
        data = -1;
    }
}

map = ggon_list_to_map(list);
ret += ggon_encode(map) + chr(10);
ggon_destroy_map(map)
ds_list_destroy(list);

return ret + "{END ENTITIES}";
