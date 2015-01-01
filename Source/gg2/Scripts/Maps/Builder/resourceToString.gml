/**
 * Turns a sprite into a string, use stringToResource to turn it back into a sprite
 * Argument0: The filename
*/

var file, s;
s = "";

file = file_bin_open(argument0, 0);
while(file_bin_position(file) < file_bin_size(file)) {
  s += chr(file_bin_read_byte(file));
}
file_bin_close(file);

return s;
