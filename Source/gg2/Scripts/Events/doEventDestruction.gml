/**
 * Perform the "building destroyed" event, i.e. change the appropriate scores,
 * destroy the building object to spawn metal and so on.
 *
 * argument0: The player whose building died
 * argument1: The player who inflicted the fatal damage (or noone if the owner demolished it)
 * argument2: The healer who assisted the destruction (or noone for no assist)
 * argument3: The source of the fatal damage
 */
var owner, killer, assistant, damageSource;
owner = argument0;
killer = argument1;
healer = argument2;
damageSource = argument3;
 
//*************************************
//*      Scoring and Kill log
//*************************************

if(instance_exists(killer) and killer != owner) {
    killer.stats[DESTRUCTION] += 1;
    killer.roundStats[DESTRUCTION] += 1;
    killer.stats[POINTS] += 1;
    killer.roundStats[POINTS] += 1;
    recordDestructionInLog(owner, killer, healer, damageSource);
    setChatBubble(owner, 60);
}
else if (argument3 == DAMAGE_SOURCE_GENERATOR_EXPLOSION) {
    recordDestructionInLog(owner, noone, noone, damageSource);
    setChatBubble(owner, 60);
}
//*************************************
//*         Scrapped
//*************************************
with(owner.sentry) {
    instance_destroy();
}
