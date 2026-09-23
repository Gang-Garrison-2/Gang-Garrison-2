// Runs an action script (menu item, Builder button, ...) with one argument.
// argument0: script to run, or -1 for none
// argument1: passed to the script as argument0
// Returns the script's result, or 0 if there is no script.
if (argument0 < 0)
    return 0;
return script_execute(argument0, argument1);
