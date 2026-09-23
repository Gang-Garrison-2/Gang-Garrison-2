// builder_init: addButton("Clear entities")
if (show_question("Are you sure you want to scrap your entities?")) {
    unloadResources();
    ds_map_clear(Builder.metadata);
    ds_map_add(Builder.metadata, "type", "meta");
    ds_map_add(Builder.metadata, "background", "ffffff");
    ds_map_add(Builder.metadata, "void", "000000");
    with (LevelEntity) instance_destroy();
}
