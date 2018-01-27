// gearSpecFrameOverlayOffset(gearSpec, classConstant, animationName, animationSubimage, xoff, yoff)
// Sets the x and y offset of the overlay for the specific animation frame
// The offset is the center of the overlay relative to the rigging point.

var gearSpec, classConstant, animationName, animationSubimage, xoff, yoff;

gearSpec = argument0;
classConstant = argument1;
animationName = argument2;
animationSubimage = argument3;
xoff = argument4;
yoff = argument5;

var redContextName, blueContextName;
redContextName = _gearSpecFrameContext(classConstant, TEAM_RED, animationName, animationSubimage);
blueContextName = _gearSpecFrameContext(classConstant, TEAM_BLUE, animationName, animationSubimage);

_gearSpecSet(gearSpec, redContextName, "xoff", xoff);
_gearSpecSet(gearSpec, redContextName, "yoff", yoff);
_gearSpecSet(gearSpec, blueContextName, "xoff", xoff);
_gearSpecSet(gearSpec, blueContextName, "yoff", yoff);
