// Initialize the gear / overlay registry
// which is a (sparse) map from the tuple (gear, sprite, subimage)
// to the tuple (gearSprite, gearSubimage, dx, dy, angle)

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

/*
var spriteId, headPoses;
spriteId = MedicRedTauntS;
headPoses = ds_map_find_value(global.headPoseInfo, spriteId);
xoff = 0;
yoff = 0;
for(m=0; m<sprite_get_number(spriteId); m+=1)
{
    if(ds_map_exists(headPoses, m))
    {
        var headPose, dx, dy, angle, xscale;
        headPose = ds_map_find_value(headPoses, m);
        dx = ds_list_find_value(headPose, 0);
        dy = ds_list_find_value(headPose, 1);
        angle = ds_list_find_value(headPose, 2);
        xscale = ds_list_find_value(headPose, 3);
        setGearOverlayInfo(spriteId, m, "PartyHat", MedicXmasHatTauntS, m, dx + xoff*xscale, dy + yoff, angle, xscale);
    }
}

ds_list_destroy(classes);
ds_list_destroy(teams);
*/
