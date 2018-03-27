/** 
 * Turns a string from resourceToString back into a sprite
 * Argument0: The resource string
 * [Argument1]: True if the resource is a background
 * [Argument2]: The output file (loads the resource if empty)
 * Returns: the loaded resource
*/

var file, name, ext;
ext = string_copy(argument0, 1, 3);
if (ext != "GIF")
{
    ext = string_copy(argument0, 2, 3);
    if (ext != "PNG")
        return -1;
}

if (is_string(argument2))
    name = argument2 + "." + ext;
else
    name = temp_directory + "\TmpResource." + ext;

file = file_bin_open(name, 2);
while(file_bin_position(file) < string_length(argument0))
    file_bin_write_byte(file, ord(string_char_at(argument0, file_bin_position(file)+1)));
file_bin_close(file);

if (!is_string(argument2))
{
    if (argument1)
        return background_add(name, 0, 0);
    else
        return sprite_add(name, 1, 1, 0, 0, 0); 
}
