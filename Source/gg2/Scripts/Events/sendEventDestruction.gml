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

writebyte(DESTROY_SENTRY, global.eventBuffer);
writebyte(ds_list_find_index(global.players, owner), global.eventBuffer);
if(killer != -1) {
    writebyte(ds_list_find_index(global.players, killer), global.eventBuffer);
} else {
    writebyte(255, global.eventBuffer);
}
if(healer != -1) {
    writebyte(ds_list_find_index(global.players, healer), global.eventBuffer);
} else {
    writebyte(255, global.eventBuffer);
}  
writebyte(damageSource, global.eventBuffer);
