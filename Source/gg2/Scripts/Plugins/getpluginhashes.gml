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
        handle = httpGet(url, -1);

        while (!httpRequestStatus(handle))
        {
            // finish it - should be quick, no need to show progress
            httpRequestStep(handle);
        }

        // errored
        if (httpRequestStatus(handle) == 2)
        {
            show_message('Error loading server-sent plugins - getting hash failed for "' + pluginname + '":#' + httpRequestError(handle));
            failed = true;
            break;
        }

        // request failed
        if (httpRequestStatusCode(handle) != 200)
        {
            show_message('Error loading server-sent plugins - getting hash failed for "' + pluginname + '":#' + string(httpRequestStatusCode(handle)) + ' ' + httpRequestReasonPhrase(handle));
            failed = true;
            break;
        }

        pluginhash = read_string(httpRequestResponseBody(handle), 32);
        httpRequestDestroy(handle);
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
