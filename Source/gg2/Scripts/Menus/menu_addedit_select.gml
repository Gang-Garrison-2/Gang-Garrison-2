// argument0 - name
// argument1 - name of the variable this setting is bound to
// argument2 - GML code to run upon change (argument0 is new value)
// Call menu_add_option right after this function to add options for the select.
// You need to add at least one option or the menu will error out.

item_name[items] = argument0;
item_type[items] = "editselect";
item_var[items] = argument1;
item_value[items] = 0; // In this case, the index of the selected option
item_script[items] = argument2;
item_options[items] = 0;
items += 1;
