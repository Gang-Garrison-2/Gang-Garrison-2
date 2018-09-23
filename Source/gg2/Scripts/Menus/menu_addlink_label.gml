// argument0 - name
// argument1 - label, will be updated after the script is run
// argument2 - GML code to execute

item_name[items] = argument0;
item_type[items] = "scriptlabel";
item_var[items] = argument1;
item_script[items] = argument2;
items += 1;
