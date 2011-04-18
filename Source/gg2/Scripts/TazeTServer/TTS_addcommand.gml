/*
Adds a command to the TTS console
argument0 - Command name
argument1 - Command script (string)
*/
ds_list_add(global.TTSCommandNames,argument0);
ds_list_add(global.TTSCommandScripts,argument1);
