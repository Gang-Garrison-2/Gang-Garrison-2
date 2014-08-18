// creates game objects per the list in the entity data
// argument0: entity data

if (string_copy(argument0, 1, 1) == "{") {
    // Read the entities that are compiled using the GGON format.
    // x, y, image_xscale and image_yscale are set by default, 
    // if the object has extra properties these should be read in its event_user(1) using the map 'other.properties'.
    
    var map, list, i;
    map = ggon_decode(argument0);
    list = ggon_map_to_list(map);
    for(i=0;i<ds_list_size(list); i+=1) {
        properties = ds_list_find_value(list, i);
        
        //Create the entity.
        var entity, data;
        data = getEntityData(ds_map_find_value(properties, "type"));
        if (data != -1) {
            if (room == BuilderRoom) {
                entity = instance_create(real(ds_map_find_value(properties, "x")), real(ds_map_find_value(properties, "y")), LevelEntity);
                entity.sprite_index = ds_map_find_value(data, "entity_sprite");
                entity.image_index = ds_map_find_value(data, "entity_image");
                entity.type = ds_map_find_value(properties, "type");
                entity.data = duplicateMap(properties);
            } else {
                entity = instance_create(real(ds_map_find_value(properties, "x")), real(ds_map_find_value(properties, "y")), ds_map_find_value(data, "object"));
                
                // Entities have access to their properties in this event.
                with(entity) event_user(1);
            }
            
            if (ds_map_exists(properties, "xscale")) entity.image_xscale = real(ds_map_find_value(properties, "xscale"));
            if (ds_map_exists(properties, "yscale")) entity.image_yscale = real(ds_map_find_value(properties, "yscale"));
        }
        ds_map_destroy(properties);
    }
    ds_map_destroy(map);
    ds_list_destroy(list);
} else {
    // Read entities that are compiled in the old format.    
    var currentPos, entityType, entityX, entityY, wordLength, DIVIDER, DIVREPLACEMENT;
    DIVIDER = chr(10);
    DIVREPLACEMENT = " ";
    
    argument0+=DIVIDER;
    
    currentPos = 1;

    while(string_pos(DIVIDER, argument0) != 0) { // continue until there are no more entities left
        // grab the entity type
        wordLength = string_pos(DIVIDER, argument0) - currentPos;
        entityType = string_copy(argument0, currentPos, wordLength);
        argument0 = string_replace(argument0, DIVIDER, DIVREPLACEMENT);
        currentPos += wordLength + string_length(DIVREPLACEMENT);
        // grab the x coordinate
        wordLength = string_pos(DIVIDER, argument0) - currentPos;
        entityX = real(string_copy(argument0, currentPos, wordLength));
        argument0 = string_replace(argument0, DIVIDER, DIVREPLACEMENT);
        currentPos += wordLength + string_length(DIVREPLACEMENT);
        // grab the y coordinate
        wordLength = string_pos(DIVIDER, argument0) - currentPos;
        entityY = real(string_copy(argument0, currentPos, wordLength));
        argument0 = string_replace(argument0, DIVIDER, DIVREPLACEMENT);
        currentPos += wordLength + string_length(DIVREPLACEMENT);
        
        var entity, obj;
        entity = getEntityData(entityType);
        if (entity != -1) {
            if (room == BuilderRoom) {
                obj = instance_create(entityX, entityY, LevelEntity);
                obj.sprite_index = ds_map_find_value(entity, "entity_sprite");
                obj.image_index = ds_map_find_value(entity, "entity_image");
                obj.type = entityType;
            } else {
                obj = instance_create(entityX, entityY, ds_map_find_value(entity, "object"));
            }
        }
    }
}
