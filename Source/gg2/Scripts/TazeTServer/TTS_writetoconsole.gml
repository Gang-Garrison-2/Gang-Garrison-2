/*
Writes to the console
argument0 - text
*/
ds_list_add(global.TTSConsoleLog,argument0);
while (ds_list_size(global.TTSConsoleLog)>10) {
    ds_list_delete(global.TTSConsoleLog,0);
}
