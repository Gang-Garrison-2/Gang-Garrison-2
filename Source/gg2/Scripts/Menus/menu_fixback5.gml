// Swap back button with last button if last button is not back button
if(menu_script_back != -1 and doSwapBack)
{
    var name, type, script;
    name = item_name[menu_script_back];
    type = item_type[menu_script_back];
    script = item_script[menu_script_back];
    
    item_name[menu_script_back] = item_name[items];
    item_type[menu_script_back] = item_type[items];
    item_script[menu_script_back] = item_script[items];
    item_var[menu_script_back] = item_var[items];
    
    item_name[items] = name;
    item_type[items] = type;
    item_script[items] = script;
    
    menu_script_back = items;
}
