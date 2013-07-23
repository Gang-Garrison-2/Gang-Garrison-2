// gets MD5 hashes for plugins from ganggarrison.com
// argument0 - comma separated plugin list 
// returns comma-separated plugin list with hashes
// or else the string 'failure'
var list, i, pluginname, pluginhash, url, handle, filesize, tempfile, failed, fp, hashedList;

failed = false;
hashedList = '';

// split plugin list string
list = csvtolist(argument0);

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
        tempfile = temp_directory + "\" + pluginname + ".md5.tmp";
    
        // let's make the download handle
        handle = DM_CreateDownload(url, tempfile);
    
        // download it
        filesize = DM_StartDownload(handle);
        while (DM_DownloadStatus(handle) != 3)
        {
            // download should be quick, no need to show progress
        }
        DM_StopDownload(handle);
        DM_CloseDownload(handle);
    
        // if the file doesn't exist, the download presumably failed
        if (!file_exists(tempfile)) {
            show_message('Error loading server-sent plugins - getting hash failed for:#"' + pluginname + '"');
            failed = true;
            break;
        }
    
        fp = file_text_open_read(tempfile);
        pluginhash = file_text_read_string(fp);
        file_text_close(fp);
        file_delete(tempfile);
    
        // check it's the right length for a hex MD5
        if (string_length(pluginhash) != 32)
        {
            show_message('Error loading server-sent plugins - getting hash failed (wrong length) for:#"' + pluginname + '"');
            failed = true;
            break;
        }
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
