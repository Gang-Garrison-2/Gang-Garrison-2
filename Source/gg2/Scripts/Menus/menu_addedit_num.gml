// argument0 - name
// argument1 - name of the variable this setting is bound to
// argument2 - GML code to run upon change (argument0 is new value)
// Note that the gml code is run *before* the bound variable is updated
item_name[items] = argument0;
item_type[items] = "editnum";
item_var[items] = argument1;
item_value[items] = string(menu_get_var(items));
item_script[items] = argument2;
items += 1;
