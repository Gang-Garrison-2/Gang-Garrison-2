// returns the width in pixels of the current map
// This is the scaled width, so on non-custom maps, it's equal to the width of the room

{
  if(room == CustomMapRoom || room == BuilderRoom) {
    return background_width[7] * background_xscale[7];
  } else {
    return room_width;
  }
}
