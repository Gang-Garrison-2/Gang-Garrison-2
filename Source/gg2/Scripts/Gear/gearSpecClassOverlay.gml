// gearSpecClassOverlay(gearSpec, classConstant, redOverlay, blueOverlay, subimage)
// Sets the default overlay for the given class and for both teams to the given sprites, both at the given subimage
// This overrides the default overlay specified using gearSpecDefaultOverlay
var gearSpec, classConstant, redOverlay, blueOverlay, subimage;

gearSpec = argument0;
classConstant = argument1;
redOverlay = argument2;
blueOverlay = argument3;
subimage = argument4;

_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_RED), "overlay", redOverlay);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_RED), "overlaySubimage", subimage);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_BLUE), "overlay", blueOverlay);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_BLUE), "overlaySubimage", subimage);
