// argument0 - name
// argument1 - name of the variable this setting is bound to
// argument2 - GML code to run upon change - argument0 is new value, return value is assigned to bound variable
// Note that the bound variable is only updated *after* the script in argument2 returns!

item_name[items] = argument0;
item_type[items] = "edittext2";
item_var[items] = argument1;
item_value[items] = menu_get_var(items);
item_script[items] = argument2;
items += 1;
