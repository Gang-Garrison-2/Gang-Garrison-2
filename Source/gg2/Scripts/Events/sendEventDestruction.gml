/**
 * Notify all clients of a "building destruction" event.
 *
 * argument0: The owner of the destroyed building
 * argument1: The player who inflicted the fatal damage (or noone for owner detonation)
 * argument2: The healer of the destroyer (or noone)
 * argument3: The source of the fatal damage
 */
var owner, killer, healer, damageSource;
owner = argument0;
killer = argument1;
healer = argument2;
damageSource = argument3;

write_ubyte(global.sendBuffer, DESTROY_SENTRY);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players, owner));
if(instance_exists(killer)) {
    write_ubyte(global.sendBuffer, ds_list_find_index(global.players, killer));
} else {
    write_ubyte(global.sendBuffer, 255);
}
if(instance_exists(healer)) {
    write_ubyte(global.sendBuffer, ds_list_find_index(global.players, healer));
} else {
    write_ubyte(global.sendBuffer, 255);
}  
write_ubyte(global.sendBuffer, damageSource);
