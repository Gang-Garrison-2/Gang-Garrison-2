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
