// This is a bad hack and I should feel bad.
// Sets the item after the last item added by the menu_add* functions to the back button.

item_type[items] = "script";
item_name[items] = menu_text_back;
item_script[items] = menu_script_back;
