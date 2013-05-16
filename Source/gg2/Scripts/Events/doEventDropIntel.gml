/**
 * Make the player <argument0> drop the intel, playing a notification sound and showing a notification
 *
 * argument0: The player who is dropping the intel. Must currently have a valid Character object with intel==true.
 */

var player, preconditionsError;
player = argument0;

sound_play(IntelDropSnd);

with(player.object)
{
    // Modify the character state appropriately
    intel = false;
    canGrabIntel = false;
    alarm[1] = 300;
    animationOffset = CHARACTER_ANIMATION_NORMAL;
    
    // Write log entry
    var isMe;
    isMe = (global.myself == player);
    recordEventInLog(5, player.team, player.name, isMe); 
    
    var newIntelObject, newIntelInstance;
    // Create dropped intel
    if (player.team == TEAM_RED)
        newIntelObject = IntelligenceBlue;
    else if (player.team == TEAM_BLUE)
        newIntelObject = IntelligenceRed;
    else
        show_error("Invalid team in intel drop event: " + string(player.team), true);
    newIntelInstance = instance_create(x, y, newIntelObject);
    newIntelInstance.alarm[0] = intelRecharge;
}
