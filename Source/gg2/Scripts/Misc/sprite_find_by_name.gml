// Returns the sprite with the given name. Errors if there is none.
// argument0: sprite name
//
// Replaces asset_get_index, which evaluated the name with execute_string
// (not available in ENIGMA). The name map is built on first use.
var sprite;
if (global.spritesByName == -1)
{
    var i;
    global.spritesByName = ds_map_create();
    // Sprite IDs are small and dense (707 sprites); scan well past the end.
    for (i = 0; i < 4096; i += 1)
        if (sprite_exists(i))
            ds_map_add(global.spritesByName, sprite_get_name(i), i);
}
if (!ds_map_exists(global.spritesByName, argument0))
{
    show_error("No sprite named [" + argument0 + "]", false);
    return -1;
}
return ds_map_find_value(global.spritesByName, argument0);
