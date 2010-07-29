// argument0: the compressed walkmask string

{

  var wm_surface; // the resulting decompressed walkmask surface
  var width, height;
  var TRANSPARENT_COLOR, SOLID_COLOR;
  var DIVIDER;
  TRANSPARENT_COLOR = c_white;
  SOLID_COLOR = c_black;
  DIVIDER = chr(10);
  
  // extract the width and height from the compressed walkmask
  var temp;
  temp = string_pos(DIVIDER, argument0);
  
  width = real(string_copy(argument0, 1, temp - 1));

  argument0 = string_copy(argument0, temp + string_length(DIVIDER), string_length(argument0) - temp);
  temp = string_pos(DIVIDER, argument0);

  height = real(string_copy(argument0, 0, temp - 1));
  argument0 = string_copy(argument0, temp + string_length(DIVIDER), string_length(argument0) - temp);
  
  // create a surface for the walkmask
  
  wm_surface = surface_create(width, height);
  surface_set_target(wm_surface);
  // fill it with transparent, so we only have to draw the solid stuff in
  draw_set_alpha(1);
  draw_set_color(TRANSPARENT_COLOR);
  draw_rectangle(0, 0, width, height, false);
  draw_set_color(SOLID_COLOR);
  
  // scan the string, drawing to the walkmask surface as we go
  var bit_mask, num_value;
  string_index = string_length(argument0);
  bit_mask = $1;
  num_value = ord(string_char_at(argument0, string_index)) - 32;
  var a, b;
  // the last character might only be partly used to describe the walkmask
  // this will pull off any junk, leaving us with the data we want
  for(a = 0; a < string_length(argument0) * 6 - (width * height); a += 1) {
    bit_mask *= 2;
  }
  for(a = height - 1; a >= 0; a -= 1) {
    for(b = width - 1; b >= 0; b -= 1) {
      if(bit_mask == 64) {
        string_index -= 1; // grab the preview character
        num_value = ord(string_char_at(argument0, string_index)) - 32;
        bit_mask = 1;
      }
      // draw a solid dot if this bit is a 1
      if(num_value & bit_mask) draw_point(b, a);
      bit_mask *= 2;
    }
  }
  
  surface_reset_target();
  
  return wm_surface;
}