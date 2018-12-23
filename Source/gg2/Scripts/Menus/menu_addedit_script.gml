// Add a menu item that calls a script when clicked, and that has a display value.
// There is no variable binding for this kind of item, the script is expected to perform
// any desired state update itself.
// Useful for things like file dialogs.
// argument0 - name
// argument1 - Initial display value
// argument2 - GML code to execute. Return value is set as new display value.

item_name[items] = argument0;
item_type[items] = "editscript";
item_value[items] = argument1;
item_script[items] = argument2;
items += 1;
