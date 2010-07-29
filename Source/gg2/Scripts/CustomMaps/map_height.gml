// returns the width in pixels of the current map
// This is the scaled width, so on non-custom maps, it's equal to the width of the room

{
  if(room == CustomMapRoom) {
    return background_height[0] * 6;
  } else {
    return room_height;
  }
}