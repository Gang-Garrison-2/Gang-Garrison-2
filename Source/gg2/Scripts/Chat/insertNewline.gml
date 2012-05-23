//argument 0: The String
//argument 1: The maximum length of a line

//Here, we shall treat the backslash hash character as only one character...

var str, current_position, current_line new_string;
str = argument0;
line_length = argument1;
current_line = str;
current_position = 0;
global_position = 0;
new_string = "";
while (string_length(current_line) > line_length){
    //start at the farthest possible position, work our way backwards (conservative)
    current_position = line_length;
    do { 
    current_position -= 1;
    } 
    until (string_char_at(current_line,line_length-current_position) == " " or current_position == 0)
    show_debug_message(current_position)
    current_line = string_copy(current_line,0,line_length-current_position)
    string_insert("#",str,string_length(str)-string_length(current_line)) // Newline
    show_debug_message("SUCXCESS")

}
return(str)
/*
var str, current_position, current_line new_string;
str = argument0;
line_length = argument1;
current_line = str;
current_position = 0;
new_string = "";
if (string_length(str) > line_length) {
    string_insert("#",str,line_length)
}

show_message(str)

*/
//return(new_string)
