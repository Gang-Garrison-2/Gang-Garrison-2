// Initialize the gear / overlay registry
// which is a (sparse) map from the tuple (gear, sprite, subimage)
// to the tuple (gearSprite, gearSubimage, dx, dy, angle)

// To define the gear positions, defined rigging points are used (see initAllHeadPoses).

var gearSpec;
gearSpec = gearSpecCreate();
gearSpecDefaultOverlay(gearSpec, RedPartyHatS, BluePartyHatS, 0);
gearSpecClassOverlayOffset(gearSpec, CLASS_ENGINEER, -2, -2);
gearSpecClassOverlayOffset(gearSpec, CLASS_SNIPER, -2, -4);
gearSpecClassOverlay(gearSpec, CLASS_QUOTE, QuerlyRedPartyHatS, QuerlyBluePartyHatS, 0);

gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 2, PyroRedTauntPartyHatS, PyroBlueTauntPartyHatS, 0);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 3, PyroRedTauntPartyHatS, PyroBlueTauntPartyHatS, 1);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 4, PyroRedTauntPartyHatS, PyroBlueTauntPartyHatS, 2);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 5, PyroRedTauntPartyHatS, PyroBlueTauntPartyHatS, 1);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 6, PyroRedTauntPartyHatS, PyroBlueTauntPartyHatS, 2);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 7, PyroRedTauntPartyHatS, PyroBlueTauntPartyHatS, 0);

gearSpecApply(gearSpec, GEAR_PARTY_HAT);
gearSpecDestroy(gearSpec);

gearSpec = gearSpecCreate();
gearSpecDefaultOverlay(gearSpec, CrownS, CrownS, 0);
gearSpecClassOverlay(gearSpec, CLASS_PYRO, CrownSmallS, CrownSmallS, 0);
gearSpecClassOverlay(gearSpec, CLASS_DEMOMAN, CrownSmallS, CrownSmallS, 0);
gearSpecClassOverlay(gearSpec, CLASS_MEDIC, CrownSmallS, CrownSmallS, 0);
gearSpecClassOverlay(gearSpec, CLASS_SNIPER, CrownSmallS, CrownSmallS, 0);
gearSpecClassOverlay(gearSpec, CLASS_QUOTE, CrownQuerlyS, CrownQuerlyS, 0);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 2, CrownBehindPyroTauntS, CrownBehindPyroTauntS, 0);
gearSpecFrameOverlay(gearSpec, CLASS_PYRO, "Taunt", 7, CrownBehindPyroTauntS, CrownBehindPyroTauntS, 0);
gearSpecClassOverlayOffset(gearSpec, CLASS_SOLDIER, 0, 2);
gearSpecClassOverlayOffset(gearSpec, CLASS_DEMOMAN, 0, 2);
gearSpecClassOverlayOffset(gearSpec, CLASS_MEDIC, 0, 2);
gearSpecClassOverlayOffset(gearSpec, CLASS_SPY, 0, 2);
gearSpecClassOverlayOffset(gearSpec, CLASS_SNIPER, 0, 0);
gearSpecApply(gearSpec, GEAR_CROWN);
gearSpecDestroy(gearSpec);

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
