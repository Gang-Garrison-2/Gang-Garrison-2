var gearSpec;
gearSpec = gearSpecCreate();
gearSpecDefaultOverlay(gearSpec, NavigatorHatS, NavigatorHatS, 0);
gearSpecClassOverlay(gearSpec, CLASS_QUOTE, NavigatorHatQuerlyS, NavigatorHatQuerlyS, 0);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 2, NavigatorHatBehindPyroTauntS, NavigatorHatBehindPyroTauntS, 0);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 7, NavigatorHatBehindPyroTauntS, NavigatorHatBehindPyroTauntS, 0);
gearSpecClassOverlayOffset(gearSpec, CLASS_SOLDIER, 2, 2);
gearSpecClassOverlayOffset(gearSpec, CLASS_HEAVY, 2, 0);
gearSpecClassOverlayOffset(gearSpec, CLASS_SPY, 2, 0);

gearSpecApply(gearSpec, GEAR_NAVIGATORHAT);
gearSpecDestroy(gearSpec);
