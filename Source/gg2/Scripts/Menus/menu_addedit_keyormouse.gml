// argument0 - name
// argument1 - name of the variable this setting is bound to
// argument2 - script to run upon change, gets the new value as argument0 (-1 for none)

item_name[items] = argument0;
item_type[items] = "editkeyormouse";
item_var[items] = argument1;
item_script[items] = argument2;
items += 1;
