// argument0 - name
// argument1 - default value
// argument2 - GML code to run upon change (argument0 is value)

item_name[items] = argument0;
item_type[items] = "editboolean";
item_value[items] = argument1;
item_script[items] = argument2;
items += 1;
