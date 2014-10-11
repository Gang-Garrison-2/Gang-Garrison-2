/** Places an entity at the given x/y position with given x/y scales
 * Argument0: X position
 * Argument1: Y position
 * Argument2: X scale
 * Argument3: Y scale
*/

with(Builder)
{
    var entity;  
    entity = instance_create(argument0, argument1, LevelEntity);
    entity.sprite_index = selectedSprite;
    entity.image_index = selectedImage;
    entity.type = ds_list_find_value(global.entities, entityButtons[selected, INDEX]);
    entity.image_xscale = argument2;
    entity.image_yscale = argument3;
    
    if (ds_map_size(newProperties) > 0)
    {
        entity.properties = ggon_duplicate_map(newProperties);
        
        // Use the correct sprite for entities with external sprites.
        var resource;
        resource = ds_map_find_value(entity.properties, "resource");
        sprite = ds_map_find_value(global.resources, resource);
        if (sprite > 0)
        {
            entity.sprite_index = sprite;
            entity.image_index = 0;
        }
    }
    
    // Custom script that which plugins can use
    execute_string(global.placeEntityFunction, entity);
}
