// builder_init: addButton("Get resources")
if (Builder.mapBG == "")
    show_message("Load a map first");
else
{
    if (!directory_exists(working_directory + "/Maps/Decompiled"))
        directory_create(working_directory + "/Maps/Decompiled");

    // Walkmask
    if (file_exists(temp_directory+"\custommap_walkmask.png"))
        file_copy(temp_directory+"\custommap_walkmask.png", working_directory + "/Maps/Decompiled/walkmask.png");    

    // External sprites     
    var resource;
    for(resource=ds_map_find_first(Builder.metadata); is_string(resource); resource = ds_map_find_next(Builder.metadata, resource))
    {   
        var bg;
        if (string_copy(resource,1, 3) == "bg_")
            bg = true;
        else
            bg = false;

        stringToResource(ds_map_find_value(Builder.metadata, resource), bg, working_directory + "/Maps/Decompiled/" + resource);
    }  
    show_message("The map has been decompiled to " + working_directory + "/Maps/Decompiled/ .");
}
