// cleans up server-sent plugins
if (global.serverPluginsInUse)
{
    // Deletes temporary directories
    var i, tempdir;
    for (i = 0; i < ds_list_size(global.serverPluginTempDirs); i += 1)
    {
        tempdir = ds_list_find_value(global.serverPluginTempDirs, i);
        
        // delete the temporary plugin directory using rmdir
        deletedir(tempdir);
    }
    ds_list_destroy(global.serverPluginTempDirs);

    // Restart or quit GG2 so that plugins aren't kept in memory
    if (show_message_ext("Because you used this server's plugins, you will have to restart GG2 to play on another server.","Restart","","Quit") == 1)
    {
        execute_program(parameter_string(0), "-restart", false);   
    }
    game_end();    
}
