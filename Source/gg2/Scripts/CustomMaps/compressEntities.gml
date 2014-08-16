//If we've reached this stage, then we are good to go. Let's start the entity creation!
var ret;
ret = "{ENTITIES}" + chr(10);

if (Builder.ggon) {
    // Compress using GGON
    var map, submap, list;
    list = ds_list_create();
    with(LevelEntity) {
        submap = ds_map_create();
        ds_map_add(submap, "type", type);
        ds_map_add(submap, "x", string(x));
        ds_map_add(submap, "y", string(y));
        if (image_xscale > 1) ds_map_add(submap, "xscale", string(image_xscale)); 
        if (image_yscale > 1) ds_map_add(submap, "yscale", string(image_yscale)); 
        ds_list_add(list, submap);
    }
    
    map = ggon_list_to_map(list);
    ret += ggon_encode(map) + chr(10);
    ggon_destroy_map(map)
    ds_list_destroy(list);
} else {
    // Old format
    with(LevelEntity){
        ret += type + chr(10);
        ret += string(x) + chr(10);
        ret += string(y) + chr(10);
    }
}
return ret + "{END ENTITIES}";
