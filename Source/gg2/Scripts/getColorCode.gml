// Returns a RGB color code from an eleven length string (seperated by anything)

var color, red, green, blue;

color = string_copy(argument0, 0, COLOR_RGB_LENGTH);

//show_message(string_copy(color,0,3)+" "+string_copy(color,5,3)+" "+string_copy(color,9,3))

red = real(string_copy(color,0,3));
green = real(string_copy(color,5,3));
blue = real(string_copy(color,9,3));

return make_color_rgb(red,green,blue);
