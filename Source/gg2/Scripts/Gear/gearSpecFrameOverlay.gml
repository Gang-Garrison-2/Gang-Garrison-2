// gearSpecFrameOverlay(gearSpec, classConstant, animationName, animationSubimage, redOverlay, blueOverlay, subimage)
var gearSpec, classConstant, animationName, animationSubimage, redOverlay, blueOverlay, subimage;

gearSpec = argument0;
classConstant = argument1;
animationName = argument2;
animationSubimage = argument3;
redOverlay = argument4;
blueOverlay = argument5;
subimage = argument6;

var redContextName, blueContextName;
redContextName = _gearSpecFrameContext(classConstant, TEAM_RED, animationName, animationSubimage);
blueContextName = _gearSpecFrameContext(classConstant, TEAM_BLUE, animationName, animationSubimage);

_gearSpecSet(gearSpec, redContextName, "overlay", redOverlay);
_gearSpecSet(gearSpec, redContextName, "overlaySubimage", subimage);
_gearSpecSet(gearSpec, blueContextName, "overlay", blueOverlay);
_gearSpecSet(gearSpec, blueContextName, "overlaySubimage", subimage);
