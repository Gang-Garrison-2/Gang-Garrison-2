// loads plugins from ganggarrison.com asked for by server
// argument0 - comma separated plugin list
var list, text, i, file, url, handle, tempdir, tempdirprefix, tempfile, failed;

failed = false;
list = ds_list_create();
text = argument0;
tempdirprefix = "~tmp-";

// split plugin list string
while (string_pos(",", text) != 0) {
    ds_list_add(list, string_copy(text,0,string_pos(",",text)-1));
    text = string_copy(text,string_pos(",",text)+1,string_length(text)-string_pos(",",text));
}
if (string_length(text) > 0) {
    ds_list_add(list, text);
}

// Check plugin names and check for duplicated
for (i = 0; i < ds_list_size(list); i += 1) {
    file = ds_list_find_value(list, i);
    
    // invalid plugin name
    if (!checkpluginname(file)) {
        show_message('Error loading server-sent plugins - invalid plugin name:#"' + file + '"');
        return false;
    // duplicate
    } else if (ds_list_find_index(list, file) != i) {
        show_message('Error loading server-sent plugins - duplicate plugin:#"' + file + '"');
        return false;
    }
}

// Download plugins
for (i = 0; i < ds_list_size(list); i += 1) {
    file = ds_list_find_value(list, i);
    
    // we need a temporary file to download to
    tempfile = working_directory + "\~" + file + ".tmp";
    
    // construct the URL (http://ganggarrison.com/plugins/$PLUGINNAME$.zip)
    url = PLUGIN_SOURCE + file + ".zip";
    
    // let's make the download handle
    handle = DM_CreateDownload(url, tempfile);
    
    // download it
    DM_StartDownload(handle);
    while (DM_DownloadStatus(handle) != 3) {}
    DM_StopDownload(handle);
    DM_CloseDownload(handle);

    // if the file doesn't exist, the download presumably failed
    if (!file_exists(tempfile)) {
        failed = true;
        break;
    } else {
        // let's choose a temporary directory name
        tempdir = working_directory + "\" + tempdirprefix + file;
        
        // let's get 7-zip to extract the files
        extractzip(tempfile, tempdir, true);
        
        // if the directory doesn't exist, extracting presumably failed
        if (!directory_exists(tempdir)) {
            failed = true;
            break;
        }
    }
}


if (!failed) {
    // Execute plugins
    for (i = 0; i < ds_list_size(list); i += 1) {
        file = ds_list_find_value(list, i);
        tempdir = working_directory + "\" + tempdirprefix + file;
        
        // Debugging facility, so we know *which* plugin caused compile/execute error
        fp = file_text_open_write(working_directory + "\last_plugin.log");
        file_text_write_string(fp, file);
        file_text_close(fp);
        
        // Execute plugin
        execute_file(
            // the plugin's main gml file must be in the root of the zip
            // it is called plugin.gml
            tempdir + "\plugin.gml",
            // the plugin needs to know where it is
            // so the temporary directory is passed as first argument
            tempdir
        );
    }
}

// Clear up
file_delete(working_directory + "\last_plugin.log");
for (i = 0; i < ds_list_size(list); i += 1) {
    file = ds_list_find_value(list, i);

    // delete the download temporary file
    tempfile = working_directory + "\~" + file + ".tmp";
    file_delete(tempfile);
    
    // delete the temporary plugin directory using rmdir
    tempdir = working_directory + "\" + tempdirprefix + file;
    deletedir(tempdir);
}
ds_list_destroy(list);

return !failed;
