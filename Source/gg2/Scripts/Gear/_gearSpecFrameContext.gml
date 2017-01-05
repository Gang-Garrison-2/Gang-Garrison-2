// _gearSpecFrameContext(classConstant, teamConstant, animationName, subimage)
var classConstant, teamConstant, animationName, subimage;

classConstant = argument0;
teamConstant = argument1;
animationName = argument2;
subimage = argument3;

return _gearSpecClassTeamContext(classConstant, teamConstant) + " " + animationName + " " + string(subimage);
