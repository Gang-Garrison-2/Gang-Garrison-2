/**
 * argument0 = team of intel being returned
 */
 
var intelObj, intelBaseObj, intelInstance;
if(argument0 == TEAM_RED)
{
    intelObj = IntelligenceRed;
    intelBaseObj = IntelligenceBaseRed;
}
else if(argument0 == TEAM_BLUE)
{
    intelObj = IntelligenceBlue;
    intelBaseObj = IntelligenceBaseBlue;
}
else 
    exit;

// Ensure that this command actually makes sense
if(!instance_exists(intelBaseObj))
    exit;

// Force players to drop their intel if it's not on the field
if(!instance_exists(intelObj))
{
    with(Character)
    {
        if(team == argument0 and intel)
            event_user(5);
    }
}
    
// Still not there? Make a new one.
if(!instance_exists(intelObj))
    instance_create(intelBaseObj.x, intelBaseObj.y, intelObj);

sound_play(IntelDropSnd);
recordEventInLog(8, argument0, "", argument0);
intelObj.x = intelBaseObj.x;
intelObj.y = intelBaseObj.y;
intelObj.alarm[0]=-1;
