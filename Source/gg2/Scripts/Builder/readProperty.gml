/** Reads a property with error checking
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
    default: 
        show_error("Unknown property type in readProperty script for '" + string(argument1) + "'.", false);
}
