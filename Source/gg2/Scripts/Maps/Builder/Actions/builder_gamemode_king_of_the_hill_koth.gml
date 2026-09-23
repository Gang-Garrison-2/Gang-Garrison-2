// builder_init: addGamemode("King of the hill (koth)")
var controlpoints, zones;
controlpoints = 0;
zones = 0;
with(LevelEntity) {
    if (type == "KothControlPoint") controlpoints += 1;
    else if (type == "CapturePoint") zones += 1;
}
if (controlpoints != 1 || zones == 0) return false;
return true;
