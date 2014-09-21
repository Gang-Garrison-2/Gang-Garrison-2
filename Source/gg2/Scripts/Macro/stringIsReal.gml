/** Checks if a string is a valid number.
 * Argument0: The string to be checked.
 * Returns true if the input is a number.
*/
if (!is_string(argument0)) return true;

var number, i, char, not_yet_dot;
not_yet_dot = true;
number = false;
for (i = 1; i <= string_length(argument0); i += 1) {
    char = string_char_at(argument0, i);
    if (("0" <= char && char <= "9") or (i == 1 && (char == '+' || char == '-')) or (char == '.' && not_yet_dot)) {
        number = true; 
        if (char == '.') { 
            not_yet_dot = false;
        }
    } else { 
        number = false; 
        break; 
    } 
} 
return number;
