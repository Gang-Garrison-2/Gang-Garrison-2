// builder_init: addButton("Load BG")
var bg;
bg = get_open_filename("PNG|*.png","");
if(bg == "") break;
Builder.mapBG = bg;
background_replace(BuilderBGB, bg, false, false);
background_xscale[7] = 6;
background_yscale[7] = 6;
