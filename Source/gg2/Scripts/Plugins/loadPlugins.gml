var pluginList, plugin, first, PluginObject, i;
first = true;
pluginList = ds_list_create();

if(!directory_exists(working_directory + "\Plugins"))
{
    directory_create(working_directory + "\Plugins");
}

while (true)
{
    if (first == true)
    {
        plugin = file_find_first("Plugins/*.gml",0);
        first = false;
    }
    else
    {
        plugin = file_find_next();
    }

    if (plugin != "")
    {
        ds_list_add(pluginList, plugin);
    }
    else
    {
        file_find_close();
        break;
    }
} 
    
PluginObject = object_add();
for(i=0; i<ds_list_size(pluginList); i+=1)
{
    with (instance_create(0,0,PluginObject))
    {
        execute_file("Plugins/"+string(ds_list_find_value(pluginList, i)),"Plugins/");
        instance_destroy();
    }
}
