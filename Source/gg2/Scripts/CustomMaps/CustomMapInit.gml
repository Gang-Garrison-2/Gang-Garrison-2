// Initializes a custom level

// argument0: filename

{
  // get the leveldata
  var leveldata, tempfile;
  tempfile = temp_directory+"\custommap_walkmask.png";
  leveldata = GG2DLL_extract_PNG_leveldata(argument0, tempfile);

  if(leveldata == "") {
    show_message("Error: this file does not contain level data.");
    break;
  }
  // handle the leveldata
  CustomMapProcessLevelData(leveldata, tempfile);
  
  background_replace(CustomMapB, argument0, false, false);
  background_xscale[0] = 6;
  background_yscale[0] = 6;
}
