// Initializes a custom level

// argument0: filename

{
  // load the background
  background_replace(CustomMapB, argument0, false, false);
  background_xscale[0] = 6;
  background_yscale[0] = 6;
  
  // get the leveldata
  var leveldata;
  leveldata = GG2DLL_extract_PNG_leveldata(argument0);
  if(leveldata == "") {
    show_message("Error: this file does not contain level data.");
    break;
  }
  // handle the leveldata
  CustomMapProcessLevelData(leveldata);
}
