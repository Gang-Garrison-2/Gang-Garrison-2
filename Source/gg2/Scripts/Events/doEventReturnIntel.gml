/**
 * argument0 = team of intel being returned
 */
sound_play(IntelDropSnd);
recordEventInLog(8, argument0, "", argument0);
if (argument0 = TEAM_RED) {
        IntelligenceRed.x = IntelligenceBaseRed.x;
        IntelligenceRed.y = IntelligenceBaseRed.y;
        IntelligenceRed.alarm[0]=-1;
    }else{
        IntelligenceBlue.x = IntelligenceBaseBlue.x;
        IntelligenceBlue.y = IntelligenceBaseBlue.y;
        IntelligenceBlue.alarm[0]=-1;
}
