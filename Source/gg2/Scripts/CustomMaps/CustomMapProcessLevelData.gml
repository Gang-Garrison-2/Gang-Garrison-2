// given a string that contains custom leveldata, this will setup everything
// - Create all instances
// - Create the walkmask sprite

// argument0: the leveldata string

{
  var entityString, walkmaskString, walkmaskSurface;
  var a, b;
  var ENTITYTAG, ENDENTITYTAG, WALKMASKTAG, ENDWALKMASKTAG, DIVIDER;
  ENTITYTAG = "{ENTITIES}";
  ENDENTITYTAG = "{END ENTITIES}";
  WALKMASKTAG = "{WALKMASK}";
  ENDWALKMASKTAG = "{END WALKMASK}";
  DIVIDER = chr(10);
  
  // grab the walkmask data
  a = string_pos(WALKMASKTAG, argument0);
  b = string_pos(ENDWALKMASKTAG, argument0);
  if(a == 0 || b == 0) {
    show_message("Error: This file does not contain valid level data.");
    break;
  }
  walkmaskString = string_copy(argument0, a + string_length(WALKMASKTAG) + string_length(DIVIDER), b - a - string_length(WALKMASKTAG) - string_length(DIVIDER) - 1);
  
  // create the walkmask surface
  walkmaskSurface = CustomMapDecompressWalkmaskToSurface(walkmaskString);
  
  // convert it to a sprite, and delete the surface
  if(global.CustomMapCollisionSprite != -1) {
    sprite_delete(global.CustomMapCollisionSprite);
  }
  global.CustomMapCollisionSprite = sprite_create_from_surface(walkmaskSurface, 0, 0, surface_get_width(walkmaskSurface), surface_get_height(walkmaskSurface), true, true, 0, 0);
  surface_free(walkmaskSurface);


  // grab the entity data
  a = string_pos(ENTITYTAG, argument0);
  b = string_pos(ENDENTITYTAG, argument0);
  if(a == 0 || b == 0) {
    show_message("Error: This file does not contain valid level data.");
    break;
  }
  entityString = string_copy(argument0, a + string_length(ENTITYTAG) + string_length(DIVIDER), b - a - string_length(ENTITYTAG) - string_length(DIVIDER) - 1);
  
  // create entities
  CustomMapCreateEntitiesFromEntityData(entityString);
}
