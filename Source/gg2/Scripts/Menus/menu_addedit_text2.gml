// argument0 - name
// argument1 - default value
// argument2 - GML code to run upon change - argument0 is value, return value becomes new value

item_name[items] = argument0;
item_type[items] = "edittext2";
item_value[items] = argument1;
item_script[items] = argument2;
items += 1;
