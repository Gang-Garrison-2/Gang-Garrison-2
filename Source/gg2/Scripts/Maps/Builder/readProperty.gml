/** 
 * Reads a property with error checking
 * Argument0: A map of properties
 * Argument1: The property name
 * Argument2: The type of the property {STRING, REAL, BOOL}
 * [Argument3]: Default value in case of error
 * Returns the property or the default value
*/

var prop;
prop = ds_map_find_value(argument0, argument1);

switch(argument2) {
    case STRING:
        if (is_string(prop)) return prop;
        return string(argument3);
    break;
    case REAL:
        if (is_string(prop) && stringIsReal(prop)) return real(prop);
        return real(argument3);
    break;
    case BOOL:
        if (is_string(prop)) {
            if (prop == "true" || prop == "false") return (prop == "true");
        }
        if (is_real(argument3)) return (argument3 == true);
        if (string(argument3) == "true") return true;
        else return false;
    break;
    case HEX:
        if (!is_string(prop)) return argument3; 
        prop = string_lower(string_replace(prop, "$", ""));
        var i, j, h;
        h = $0;
        for(i=1; i<=string_length(prop); i+=1) {
            j = string_pos(string_char_at(prop, i), "0123456789abcdef")-1;
            if (j < 0)
                return $0;
            h = (h|j)*16;
        }
        return h/16;        
    break;
    default: 
        show_error("Unknown property type in readProperty script for '" + string(argument1) + "'.", false);
}
