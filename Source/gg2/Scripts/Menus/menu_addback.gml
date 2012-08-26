// Add a "back" action. This will also be run on pressing escape.
// Only one "back" action per menu is allowed.
// argument0 - name
// argument1 - GML code to execute

menu_addlink(argument0, argument1);
menu_script_back = argument1;
