/**
 * The player given in argument0 has just recovered the intel for his team.
 */

sound_play(IntelPutSnd);
var isMe;
isMe = (argument0 == global.myself);
//recordEventInLog(3, argument0.team, argument0.name);
recordEventInLog(3, argument0.team, argument0.name, isMe);
argument0.stats[CAPS] += 1;
argument0.roundStats[CAPS] += 1;
argument0.stats[POINTS] += 2;
argument0.roundStats[POINTS] += 2;
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
