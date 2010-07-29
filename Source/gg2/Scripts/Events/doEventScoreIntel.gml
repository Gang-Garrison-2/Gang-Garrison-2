/**
 * The player given in argument0 has just recovered the intel for his team.
 */

sound_play(IntelPutSnd);
recordEventInLog(3, argument0.team, argument0.name);
argument0.caps += 1;
if(argument0.team == TEAM_RED) {
    global.redCaps += 1;
    instance_create(IntelligenceBaseBlue.x, IntelligenceBaseBlue.y, IntelligenceBlue);
} else if(argument0.team == TEAM_BLUE) {
    global.blueCaps += 1;
    instance_create(IntelligenceBaseRed.x, IntelligenceBaseRed.y, IntelligenceRed);
} else {
    exit;
}

if(argument0.object != -1) {
    argument0.object.intel = false;
    argument0.object.animationOffset = CHARACTER_ANIMATION_NORMAL;
}