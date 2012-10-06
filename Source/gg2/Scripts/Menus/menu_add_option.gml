// Add an option to a previously created select entry. Only call this function directly after menu_addedit_select!
// argument0: The value of this option. This will be assigned to the bound variable of the select if this option is chosen
// argument1: A label that represents this option in the menu.

item_option_value[items-1, item_options[items-1]] = argument0;
item_option_label[items-1, item_options[items-1]] = argument1;
if(menu_get_var(items-1)==argument0)
    item_value[items-1] = item_options[items-1];
item_options[items-1] += 1;
