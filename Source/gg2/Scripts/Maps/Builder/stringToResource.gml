/** Turns a string from resourceToString back into a sprite
 * Argument0: The resource string
 * [Argument1]: True if the resource is a background
 * Returns: the loaded resource
*/

var file, ext;
ext = string_copy(argument0, 1, 3);
if (ext != "GIF")
{
    ext = string_copy(argument0, 2, 3);
    if (ext != "PNG")
    {
        show_error("Error trying to load non-gif or non-png resource.", false);
        return -1;
    }
}


file = file_bin_open(temp_directory + "\TmpResource." + ext, 2);
while(file_bin_position(file) < string_length(argument0))
    file_bin_write_byte(file, ord(string_char_at(argument0, file_bin_position(file)+1)));
file_bin_close(file);

if (argument1)
    return background_add(temp_directory + "\TmpResource." + ext, 0, 0);
else
    return sprite_add(temp_directory + "\TmpResource." + ext, 1, 1, 0, 0, 0); 

