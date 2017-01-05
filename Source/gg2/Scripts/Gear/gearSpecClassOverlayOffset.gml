// gearSpecClassOverlayOffset(gearSpec, classConstant, xoff, yoff)
// Sets the default x and y offset of the overlay for the given class
var gearSpec, classConstant, xoff, yoff;

gearSpec = argument0;
classConstant = argument1;
xoff = argument2;
yoff = argument3;

_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_RED), "xoff", xoff);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_RED), "yoff", yoff);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_BLUE), "xoff", xoff);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_BLUE), "yoff", yoff);
