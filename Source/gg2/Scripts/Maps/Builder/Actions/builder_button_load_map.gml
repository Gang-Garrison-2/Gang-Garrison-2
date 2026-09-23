// builder_init: addButton("Load map")
var map;
map = get_open_filename("PNG|*.png","");
if (map == "") break;

with(LevelEntity) instance_destroy();
unloadResources();
ds_map_clear(Builder.metadata);
ds_map_add(Builder.metadata, "type", "meta");
ds_map_add(Builder.metadata, "background", "ffffff");

CustomMapInit(map)
Builder.mapBG = map;  
Builder.mapWM = " ";
Builder.wmString = compressWalkmask();
loadMetadata(Builder.metadata, true);
