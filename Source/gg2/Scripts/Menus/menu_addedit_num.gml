// argument0 - name
// argument1 - name of the variable this setting is bound to
// argument2 - GML code to run upon change (argument0 is new value)
// argument3 - limit. If this is not 0, the value will be limited to this.
item_name[items] = argument0;
item_type[items] = "editnum";
item_var[items] = argument1;
item_value[items] = string(menu_get_var(items));
item_script[items] = argument2;
item_limit[items] = argument3;
items += 1;
