/*
Follows Standard Console API v1 spec
http://www.ganggarrison.com/forums/index.php?topic=33394

From the spec:

real ConsoleRunCommand(string name, string args)
- Runs command with specified name, passing the arguments value args (i.e.
  argument0 value passed to script is args), returns false if command does not
  exist, otherwise true.
*/

var i;
i = ds_list_find_index(global.ConsoleCommandNames,argument0);
if (i != -1) {
    execute_string(ds_list_find_value(global.ConsoleCommandScripts, i), argument1);
    return true;
}else{
    return false;
}
