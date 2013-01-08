/*
Runs a console command
argument0 - Command name
argument1 - Args

return value - true if command exists, false if does not exist
*/
var i;
i = ds_list_find_index(global.ConsoleCommandNames,argument0);
if (i != -1) {
    execute_string(ds_list_find_value(global.ConsoleCommandScripts, i), argument1);
    return true;
}else{
    return false;
}
