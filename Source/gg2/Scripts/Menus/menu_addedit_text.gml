// argument0 - name
// argument1 - name of the variable this setting is bound to
// argument2 - GML code to run upon change (argument0 is new value)

item_name[items] = argument0;
item_type[items] = "edittext";
item_var[items] = argument1;
item_value[items] = menu_get_var(items);
item_script[items] = argument2;
items += 1;
