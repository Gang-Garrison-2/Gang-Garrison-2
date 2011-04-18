/*
Runs a TTS Console command
argument0 - Command name
argument1 - Args

return value - true if command exists, false if does not exist
*/
var i;
i = ds_list_find_index(global.TTSCommandNames,argument0);
if (i != -1) {
    with (instance_create(0,0,PluginSandbox)) {
        execute_string(ds_list_find_value(global.TTSCommandScripts,i),argument1);
        instance_destroy();
    }
    return true;
}else{
    return false;
}
