// Add a "back" action. This will also be run on pressing escape.
// Only one "back" action per menu is allowed.
// argument0 - name
// argument1 - GML code to execute

if(menu_script_back == -1)
{
    menu_script_back = items;
    menu_addlink(argument0, argument1);
}
