//If we've reached this stage, then we are good to go. Let's start the entity creation!
var ret;
ret = "{ENTITIES}" + chr(10);

// Compress using GGON
var map, submap, list, props, key;
list = ds_list_create();
with(LevelEntity) {
    if (data == "") {
        submap = ds_map_create();
        ds_map_add(submap, "type", type);
        ds_map_add(submap, "x", string(x));
        ds_map_add(submap, "y", string(y));
        if (image_xscale != 1) ds_map_add(submap, "xscale", string(image_xscale)); 
        if (image_yscale != 1) ds_map_add(submap, "yscale", string(image_yscale));
        
        // Copy extra properties
        if (properties != "") {
            props = ggon_decode(properties);
            for(key = ds_map_find_first(props); is_string(key); key = ds_map_find_next(props, key)) {
                ds_map_add(submap, key, ds_map_find_value(props, key));
            }
            ds_map_destroy(props);
        }
    } else {
        // This is a precompiled enitity (when loading a compiled map for example)
        submap = ggon_decode(data);
    }
    
    ds_list_add(list, submap);
}

map = ggon_list_to_map(list);
ret += ggon_encode(map) + chr(10);
ggon_destroy_map(map)
ds_list_destroy(list);

return ret + "{END ENTITIES}";
