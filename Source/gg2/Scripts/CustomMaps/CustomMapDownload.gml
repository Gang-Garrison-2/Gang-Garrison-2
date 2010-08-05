{
  var animation_timer, downloadTimeout, downloadHandle, content_type, download_string, i;
  animation_timer = 61;
  downloadTimeout = 30 * room_speed;
  downloading = false;
 
  // we already have the map, so do a validity check and launch the map
  // check if it matches the server's copy
  if(file_exists("Maps/" + global.currentMap + ".png")) {
    if(CustomMapGetMapMD5(global.currentMap) == global.currentMapMD5) {
        room_goto_fix(CustomMapRoom);
        exit;
    } else {
    // our map isn't the same ask if you want to delete map
        if(show_question("The server's copy of the map (" + global.currentMap + ") differs from ours.#Would you like to download this server's version of the map?")){
            file_delete("Maps/" + global.currentMap + ".png");
            file_delete("Maps/" + global.currentMap + ".locator");
        }
        else {
            game_end();
            exit;
        }
    }
  }
 
  if(!file_exists("Maps/" + global.currentMap + ".png")) {
    // we don't have the map, so download it
    if(global.currentMapURL == "") {
      show_message("Server went to custom map " + global.currentMap + ".#We don't have that map, and the server didn't tell us where to download it.#Exiting");
      game_end();
      exit;
    }
    downloadHandle = DM_CreateDownload(global.currentMapURL, "Maps/" + global.currentMap + ".png");
    DM_StartDownload(downloadHandle);
    while(DM_DownloadStatus(downloadHandle) != 3) { // while download isn't finished
      sleep(floor(1000/30)); // sleep for the equivalent of one frame
      io_handle(); // this prevents GameMaker from appearing locked-up
 
      // check if the user cancelled the download with the esc key
      if(keyboard_check(vk_escape)) {
        show_message("Download cancelled.#Exiting");
        game_end();
        exit;
      }
 
      downloadTimeout = downloadTimeout - 1;
      if(downloadTimeout <= 0 && DM_DownloadStatus(downloadHandle) < 2) {
        show_message("Timed out while attempting to download map " + global.currentMap + ".#Exiting");
        game_end();
        exit;
      }
     
      // draw event here
      if(room == Lobby || room = Menu) {
        draw_background_stretched(MenuBackgroundB, 0, 0, 600, 600);
      } else {
        draw_background_stretched(MenuBackgroundB, 0, -100, 800, 800);
      }
 
      animation_timer = animation_timer + 1;
      if(animation_timer >= 90) animation_timer = 0;
      display_string = "Loading.";
      for(i = 0; i < (animation_timer div 30); i += 1) display_string += ".";
 
      draw_set_alpha(1);
      draw_set_color(c_black);
      draw_set_halign(fa_left);
      draw_text_transformed(30, 550, display_string, 3, 3, 0);
 
      screen_refresh();
    }
    // verify that this is, in fact, a png (and not html, or an exe, or whatever
    // NOTE: this is a security measure, but probably a very weak one
    content_type = DM_GetContentType(downloadHandle);
    if(content_type != "image/png") {
      show_message("Invalid download data.#Exiting");
      DM_StopDownload(downloadHandle);
      DM_CloseDownload(downloadHandle);
      file_delete("Maps/" + global.currentMap + ".png");
      game_end();
      exit;
    }
    DM_StopDownload(downloadHandle);
    DM_CloseDownload(downloadHandle);
   
    // save the locator so that we can host with this map in the future
    var locatorFile;
    locatorFile = file_text_open_write("Maps/" + global.currentMap + ".locator");
    file_text_write_string(locatorFile, global.currentMapURL);
    file_text_close(locatorFile);
  }
 //now we have the map check if its the same as the servers map
  if(CustomMapGetMapMD5(global.currentMap) == global.currentMapMD5) {
  room_goto_fix(CustomMapRoom);
  exit;
  }else{
  // our map isn't the same, locator points to diffrent map
  show_message("The server's locator for " +global.currentMap+ " points to a different map");
game_end();
exit;
}
}
