// gets MD5 hashes for plugins from ganggarrison.com
// argument0 - comma separated plugin list 
// returns comma-separated plugin list with hashes
// or else the string 'failure'
var list, i, pluginname, pluginhash, url, handle, filesize, failed, fp, hashedList;

failed = false;
hashedList = '';

// split plugin list string
list = split(argument0, ',');

// Check plugin names and check for duplicates
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);
    
    // invalid plugin name
    if (!checkpluginname(pluginname))
    {
        show_message('Error loading server-sent plugins - invalid plugin name:#"' + pluginname + '"');
        return 'failure';
    }
    // is duplicate
    else if (ds_list_find_index(list, pluginname) != i)
    {
        show_message('Error loading server-sent plugins - duplicate plugin:#"' + pluginname + '"');
        return 'failure';
    }
}

// Download plugin hashes
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);

    // check if we have a debug version
    if (file_exists(working_directory + "\ServerPluginsDebug\" + pluginname + ".zip"))
    {
        // get its hash instead
        pluginhash = GG2DLL_compute_MD5(working_directory + "\ServerPluginsDebug\" + pluginname + ".zip");
    }
    else
    {   
        // construct the URL
        // (http://www.ganggarrison.com/plugins/$PLUGINNAME$.md5)
        url = PLUGIN_SOURCE + pluginname + ".md5";
    
        // let's make the request handle
        handle = http_new_get(url);

        while (!http_step(handle))
        {
            // should be quick, no need to show progress
        }

        // request failed
        if (http_status_code(handle) != 200)
        {
            if (http_status_code(handle) == 404)
                show_message('Error loading server-sent plugins - getting hash failed for "' + pluginname + '":#404 Not Found - This most likely means there is no plugin with that name. Are you sure you spelled it correctly? Please note that plugin names are always lowercase, and you cannot have spaces between the commas in ServerPluginList.');
            else
                show_message('Error loading server-sent plugins - getting hash failed for "' + pluginname + '":#' + string(http_status_code(handle)) + ' ' + http_reason_phrase(handle));
            failed = true;
            break;
        }

        pluginhash = read_string(http_response_body(handle), 32);
        http_destroy(handle);
    }

    // append name + hash to list
    // (used by client to check if cache is valid)
    if (i != 0)
    {
        hashedList += ',';
    }
    hashedList += pluginname + '@' + pluginhash;
}

// Get rid of plugin list
ds_list_destroy(list);

if (failed)
{
    return 'failure';
}
else
{
    return hashedList;
}
