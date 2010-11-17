// Initializes a custom level

// argument0: filename

{
  // load the background
  
  // get the leveldata
  var leveldata;
  set_automatic_draw(0)
  draw_clear(c_white)
  draw_text_transformed(200,200,"LOADING...",2,2,0)
  leveldata = GG2DLL_extract_PNG_leveldata(argument0);
  if(leveldata == "") {
    set_automatic_draw(1)
    show_message("Error: this file does not contain level data.");
    break;
  }
  // handle the leveldata
  CustomMapProcessLevelData(leveldata);
  
  background_replace(CustomMapB, argument0, false, false);
  background_xscale[0] = 6;
  background_yscale[0] = 6;
}
