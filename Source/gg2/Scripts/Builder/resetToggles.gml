/**
 * Executes the toggle buttons' state to their default
*/

with(Builder) {
    var i, button;
    for(i=0; i<ds_list_size(global.buttons); i+=1) {
        button = ds_list_find_value(global.buttons, i);
        if (ds_map_find_value(button, "toggle")) {
            buttons[i, TOGGLED] = execute_string(ds_map_find_value(button, "code"), buttons[i, TOGGLED]);
        }
    }
}
