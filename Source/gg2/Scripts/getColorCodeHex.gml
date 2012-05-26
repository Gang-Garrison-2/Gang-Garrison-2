// Returns a color string indicated by a 6-digit hex code in RGB
var color, red, green, blue;

color = string_copy(argument0, 0, 6);


// Now because game maker is awesome, if you use hex numbers as base you need to use the format BGR instead of RGB
// So convert from RGB to BGR
color = string_copy(color, 4, 2) + string_copy(color, 2, 2) + string_copy(color, 0, 2);

exit;
return "$"+color; 
