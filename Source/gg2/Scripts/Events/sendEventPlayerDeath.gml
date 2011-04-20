/**
 * Notify all clients of a "player death" event.
 *
 * argument0: The player whose character died
 * argument1: The player who inflicted the fatal damage (or a false value for unknown)
 * argument2: The assistant (or a false value for none)
 * argument3: The source of the fatal damage
 */
var victim, killer, assistant, damageSource;
victim = argument0;
killer = argument1;
assistant = argument2;
damageSource = argument3;

write_ubyte(global.eventBuffer, PLAYER_DEATH);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, victim));
if(killer and instance_exists(killer)) {
    write_ubyte(global.eventBuffer, ds_list_find_index(global.players, killer));
} else {
    write_ubyte(global.eventBuffer, 255);
}
if(assistant and instance_exists(assistant)) {
    write_ubyte(global.eventBuffer, ds_list_find_index(global.players, assistant));
} else {
    write_ubyte(global.eventBuffer, 255);
}  
write_ubyte(global.eventBuffer, damageSource);
