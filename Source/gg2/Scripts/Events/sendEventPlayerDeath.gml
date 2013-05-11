/**
 * Notify all clients of a "player death" event.
 *
 * argument0: The player whose character died
 * argument1: The player who inflicted the fatal damage (or noone)
 * argument2: The assistant (or a false value for none)
 * argument3: The source of the fatal damage
 */
var victim, killer, assistant, damageSource;
victim = argument0;
killer = argument1;
assistant = argument2;
damageSource = argument3;

write_ubyte(global.sendBuffer, PLAYER_DEATH);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players, victim));
if(instance_exists(killer))
    write_ubyte(global.sendBuffer, ds_list_find_index(global.players, killer));
else
    write_ubyte(global.sendBuffer, 255);
    
if(instance_exists(assistant))
    write_ubyte(global.sendBuffer, ds_list_find_index(global.players, assistant));
else
    write_ubyte(global.sendBuffer, 255);

write_ubyte(global.sendBuffer, damageSource);
