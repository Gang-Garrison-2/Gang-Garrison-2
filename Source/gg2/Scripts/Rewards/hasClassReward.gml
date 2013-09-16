// real hasClassReward(real player, string rewardName)
// Returns true if this Player has the specific class-specific reward

var player, rewardName;
player = argument0;
rewardName = argument1;


// No set of rewards
if (player.rewards == -1)
{
    return false;
}
// Have for all classes
else
{
    return (
        // Have for all classes
        ds_map_exists(player.rewards, rewardName + 'All')
        // Have it for this class
        || ds_map_exists(player.rewards, rewardName + global.classAbbreviations[player.class])
    );
}
