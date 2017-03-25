// Initializes a custom level

// argument0: filename

{
  // get the leveldata
  var leveldata, tempfile;
  tempfile = temp_directory+"\custommap_walkmask.png";
  leveldata = GG2DLL_extract_PNG_leveldata(argument0, tempfile);

  if(leveldata == "") {
    show_message("Error: this file does not contain level data.");
    return false;
  }
  // handle the leveldata
  if (!CustomMapProcessLevelData(leveldata, tempfile)) return false;
  
  if (room == BuilderRoom) background_replace(BuilderBGB, argument0, false, false);
  else background_replace(CustomMapB, argument0, false, false);

  return true;
}
