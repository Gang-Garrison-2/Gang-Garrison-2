// Returns a RGB color code from an eleven length string (seperated by anything)

var color, red, green, blue;

color = string_copy(argument0, 0, COLOR_RGB_LENGTH);
red = real(string_copy(color,0,3))
green = real(string_copy(color,5,3))
blue = real(string_copy(color,10,3))


return make_color_rgb(red,green,blue)
