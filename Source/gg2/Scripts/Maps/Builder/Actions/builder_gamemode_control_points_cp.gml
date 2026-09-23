// builder_init: addGamemode("Control points (cp)")
var controlpoints, zones;
controlpoints = 0;
zones = 0;
with(LevelEntity) {
    if (type == "controlPoint1" || type == "controlPoint2" || type == "controlPoint3" || type == "controlPoint4" || type == "controlPoint5") controlpoints += 1;
    else if (type == "CapturePoint") zones += 1;
}
if (controlpoints == 0 || controlpoints > 5 || zones == 0) return false;
return true;
