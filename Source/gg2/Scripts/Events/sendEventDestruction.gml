/**
 * Notify all clients of a "building destruction" event.
 *
 * argument0: The owner of the destroyed building
 * argument1: The player who inflicted the fatal damage (or -1 for owner detonation)
 * argument2: The healer of the destroyer (or -1 for none)
 * argument3: The source of the fatal damage
 */
var owner, killer, healer, damageSource;
owner = argument0;
killer = argument1;
healer = argument2;
damageSource = argument3;

write_ubyte(global.eventBuffer, DESTROY_SENTRY);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, owner));
if(killer != -1) {
    write_ubyte(global.eventBuffer, ds_list_find_index(global.players, killer));
} else {
    write_ubyte(global.eventBuffer, 255);
}
if(healer != -1) {
    write_ubyte(global.eventBuffer, ds_list_find_index(global.players, healer));
} else {
    write_ubyte(global.eventBuffer, 255);
}  
write_ubyte(global.eventBuffer, damageSource);
