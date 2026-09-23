// builder_init: addGamemode("Arena (arena)")
var controlpoints, zones;
controlpoints = 0;
zones = 0;
with(LevelEntity) {
    if (type == "ArenaControlPoint") controlpoints += 1;
    else if (type == "CapturePoint") zones += 1;
}
if (controlpoints != 1 || zones == 0) return false;
return true;
