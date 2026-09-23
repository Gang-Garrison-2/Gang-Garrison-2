// builder_init: addButton("Add resource")
var prop;
prop = get_string("Resource name:", "");
if (prop != "")
{
    resource = get_open_filename("Resource (PNG, GIF)|*.png;*.gif;","");
    if (resource == "")
        break;
    ds_map_add(Builder.metadata, prop, resourceToString(resource));
    loadMetadata(Builder.metadata, true);
}
