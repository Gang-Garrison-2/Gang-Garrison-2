// builder_init: addGamemode("Dual king of the hill (dkoth)")
var redcontrolpoints, bluecontrolpoints, zones;
redcontrolpoints = 0;
bluecontrolpoints = 0;
zones = 0;
with(LevelEntity) {
    if (type == "KothRedControlPoint") redcontrolpoints += 1;
    else if (type == "KothBlueControlPoint") bluecontrolpoints += 1;
    else if (type == "CapturePoint") zones += 1;
}
if (redcontrolpoints != 1 || bluecontrolpoints != 1 || zones == 0) return false;
return true;
