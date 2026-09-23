// argument0 - name
// argument1 - name of the variable this setting is bound to
// argument2 - script to run upon change, gets the new value as argument0 (-1 for none)

menu_addedit_select(argument0, argument1, argument2);

menu_add_option(false, "No");
menu_add_option(true, "Yes");
