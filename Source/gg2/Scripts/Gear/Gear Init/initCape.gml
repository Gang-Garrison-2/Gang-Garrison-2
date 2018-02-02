var gearSprite, gearName, gearSpec;
gearSprite = argument0;
gearName = argument1;

gearSpec = gearSpecCreate();
gearSpecDefaultOverlay(gearSpec, gearSprite, gearSprite, 0);
gearSpecDefaultSubimageScript(gearSpec, getCapeSubimage);
gearSpecDefaultZindex(gearSpec, 10);
gearSpecClassOverlay(gearSpec, CLASS_QUOTE, -1, -1, 0); // No cape for Querly (Curly's hair gets in the way, among other things)
gearSpecClassOverlayOffset(gearSpec, CLASS_SCOUT, 0, 0);
gearSpecClassOverlayOffset(gearSpec, CLASS_PYRO, -6, 0);
gearSpecClassOverlayOffset(gearSpec, CLASS_SOLDIER, 0, 2);
gearSpecClassOverlayOffset(gearSpec, CLASS_HEAVY, -2, 2);
gearSpecClassOverlayOffset(gearSpec, CLASS_DEMOMAN, -4, 0);
gearSpecClassOverlayOffset(gearSpec, CLASS_MEDIC, -2, 2);
gearSpecClassOverlayOffset(gearSpec, CLASS_ENGINEER, 0, 0);
gearSpecClassOverlayOffset(gearSpec, CLASS_SPY, 2, 6);
gearSpecClassOverlayOffset(gearSpec, CLASS_SNIPER, 0, 0);

// Fix up Pyro's head moving relative to their shoulders
var i;
for(i=3; i<=6; i+=1) {
    gearSpecFrameOverlayOffset(gearSpec, CLASS_PYRO, "Taunt", i, -4, 0);
}

// Fix up Demoman's head moving relative to their shoulders
for(i=3; i<=7; i+=1) {
    gearSpecFrameOverlayOffset(gearSpec, CLASS_DEMOMAN, "Taunt", i, -2, 0);
}

// Fix up Medic's head moving relative to their shoulders
for(i=2; i<=3; i+=1) {
    gearSpecFrameOverlayOffset(gearSpec, CLASS_MEDIC, "Taunt", i, 0, 2);
}

// Medic's taunt makes the cape look stupid, luckily it works OK to just hide it for the affected frames
for(i=6; i<=9; i+=1) {
    gearSpecFrameOverlay(gearSpec, CLASS_MEDIC, "Taunt", i, -1, -1, 0);
}

// Fix up Heavy's head moving relative to their shoulders
var frames;
frames = split("-4,2|-4,2|-4,2|-2,2|-2,2|-4,2|-4,0|-4,2|-2,2|-2,2|-4,2|-4,2", "|");

for(i=0; i<ds_list_size(frames); i+=1)
{
    var dx_dy;
    dx_dy = split(ds_list_find_value(frames, i), ",");
    dx = real(ds_list_find_value(dx_dy, 0));
    dy = real(ds_list_find_value(dx_dy, 1));
        
    ds_list_destroy(dx_dy);
    gearSpecFrameOverlayOffset(gearSpec, CLASS_HEAVY, "Taunt", i, dx, dy);
}

for(i=2; i<=30; i+=1) {
    gearSpecFrameOverlayOffset(gearSpec, CLASS_HEAVY, "Omnomnomnom", i, -4, 2);
}

ds_list_destroy(frames);

gearSpecApply(gearSpec, gearName);
gearSpecDestroy(gearSpec);
