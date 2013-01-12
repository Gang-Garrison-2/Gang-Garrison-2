// loads plugins from ganggarrison.com asked for by server
// argument0 - comma separated plugin list
var list, text, i, file, handle, tempfile, failed;

failed = false;
list = ds_list_create();
text = argument0;

while (string_pos(",", text) != 0) {
    ds_list_add(list, string_copy(text,0,string_pos(",",text)-1));
    text = string_copy(text,string_pos(",",text)+1,string_length(text)-string_pos(",",text));
}
if (string_length(text) > 0) {
    ds_list_add(list, text);
}

// Download plugins
for (i = 0; i < ds_list_size(list); i += 1) {
    file = ds_list_find_value(list, i);
    tempfile = working_directory + "\~" + file + ".tmp";
    handle = DM_CreateDownload(PLUGIN_SOURCE + file + ".gml", tempfile);
    
    DM_StartDownload(handle);
    while (DM_DownloadStatus(handle) != 3) {}
    DM_StopDownload(handle);
    DM_CloseDownload(handle);

    if (!file_exists(tempfile)) {
        failed = true;
        break;
    }
}

if (!failed) {
    // Execute plugins
    for (i = 0; i < ds_list_size(list); i += 1) {
        file = ds_list_find_value(list, i);
        tempfile = working_directory + "\~" + file + ".tmp";
        // Debugging facility, so we know *which* plugin caused compile/execute error
        fp = file_text_open_write(working_directory + "\last_plugin.log");
        file_text_write_string(fp, file);
        file_text_close(fp);
        // Execute    
        execute_file(tempfile);
    }
}



// Clear up
file_delete(working_directory + "\last_plugin.log");
for (i = 0; i < ds_list_size(list); i += 1) {
    file = ds_list_find_value(list, i);
    tempfile = working_directory + "\~" + file + ".tmp";
    file_delete(tempfile);
}
ds_list_destroy(list);

return !failed;
