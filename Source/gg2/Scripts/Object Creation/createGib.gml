//argument 0: x
//argument 1: y
//argument 2: Object
//argument 3: base hspeed
//argument 4: base vspeed
//argument 5: rotatespeed
//argument 6: image_index
//argument 7: override randomized hs/vspeed
var gib;
gib = instance_create(argument0,argument1,argument2);
if (argument7) {
    gib.hspeed = argument3;
    gib.vspeed = argument4;
}else{
    gib.hspeed = (argument3+random_range(-8,9));
    gib.vspeed = (argument4+random_range(-8,9));
}
gib.rotspeed = argument5;
gib.image_index = argument6;
