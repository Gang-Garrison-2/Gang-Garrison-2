// builder_init: addButton("Load WM")
var wm;
wm = get_open_filename("Walkmask Image (PNG or BMP)|*.png; *.bmp","");
if(wm == "") break;
Builder.mapWM = wm;
background_replace(BuilderWMB, wm, true, false);
Builder.wmString = compressWalkmask();
