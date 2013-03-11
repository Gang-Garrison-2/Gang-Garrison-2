// loads plugins from ganggarrison.com asked for by server
// argument0 - comma separated plugin list
var list, text, i, pluginname, url, handle, tempfileprefix, tempdirprefix, failed;

failed = false;
list = ds_list_create();
text = argument0;
tempfileprefix = temp_directory + "\tmp-";
tempdirprefix = temp_directory + "\~tmp-";

// split plugin list string
while (string_pos(",", text) != 0)
{
    ds_list_add(list, string_copy(text,0,string_pos(",",text)-1));
    text = string_copy(text,string_pos(",",text)+1,string_length(text)-string_pos(",",text));
}
if (string_length(text) > 0)
{
    ds_list_add(list, text);
}

// Check plugin names and check for duplicates
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);
    
    // invalid plugin name
    if (!checkpluginname(pluginname))
    {
        show_message('Error loading server-sent plugins - invalid plugin name:#"' + pluginname + '"');
        return false;
    }
    // is duplicate
    else if (ds_list_find_index(list, pluginname) != i)
    {
        show_message('Error loading server-sent plugins - duplicate plugin:#"' + pluginname + '"');
        return false;
    }
}

// Download plugins
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);
    
    // check to see if we have a local copy for debugging
    if (file_exists("ServerPluginsDebug\" + pluginname + ".zip")) {
        file_copy("ServerPluginsDebug\" + pluginname + ".zip", tempfileprefix + pluginname);
    }
    // otherwise, download as usual
    else
    {
        // construct the URL (http://ganggarrison.com/plugins/$PLUGINNAME$.zip)
        url = PLUGIN_SOURCE + pluginname + ".zip";
        
        // let's make the download handle
        handle = DM_CreateDownload(url, tempfileprefix + pluginname);
        
        // download it
        DM_StartDownload(handle);
        while (DM_DownloadStatus(handle) != 3) {}
        DM_StopDownload(handle);
        DM_CloseDownload(handle);
    }

    // if the file doesn't exist, the download presumably failed
    if (!file_exists(tempfileprefix + pluginname)) {
        show_message('Error loading server-sent plugins - download failed for:#"' + pluginname + '"');
        failed = true;
        break;
    }
    else
    { 
        // let's get 7-zip to extract the files
        extractzip(tempfileprefix + pluginname, tempdirprefix + pluginname);
        
        // if the directory doesn't exist, extracting presumably failed
        if (!directory_exists(tempdirprefix + pluginname))
        {
            show_message('Error loading server-sent plugins - extracting zip failed for:#"' + pluginname + '"');
            failed = true;
            break;
        }
    }
}


if (!failed)
{
    // Execute plugins
    for (i = 0; i < ds_list_size(list); i += 1)
    {
        pluginname = ds_list_find_value(list, i);
        
        // Debugging facility, so we know *which* plugin caused compile/execute error
        fp = file_text_open_write(working_directory + "\last_plugin.log");
        file_text_write_string(fp, pluginname);
        file_text_close(fp);
        
        // Execute plugin
        execute_file(
            // the plugin's main gml file must be in the root of the zip
            // it is called plugin.gml
            tempdirprefix + pluginname + "\plugin.gml",
            // the plugin needs to know where it is
            // so the temporary directory is passed as first argument
            tempdirprefix + pluginname
        );
    }
}

// Clear up
file_delete(working_directory + "\last_plugin.log");
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);

    // delete the download temporary file
    file_delete(tempfileprefix + pluginname);
    
    // delete the temporary plugin directory using rmdir
    deletedir(tempdirprefix + pluginname);
}
ds_list_destroy(list);

return !failed;
