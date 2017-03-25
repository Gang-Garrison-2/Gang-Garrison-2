// void ggon_destroy_map(real map)
// Destroys a ds_map recursively (real values assumed to be ds_maps)

var map;
map = argument0;

var key, value;
for (key = ds_map_find_first(map); is_string(key); key = ds_map_find_next(map, key))
{
    value = ds_map_find_value(map, key);
    if (is_real(value))
        ggon_destroy_map(value);
}

ds_map_destroy(map);
