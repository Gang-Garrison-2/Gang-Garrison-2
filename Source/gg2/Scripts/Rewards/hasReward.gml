// real hasReward(real player, string rewardName)
// Returns true if this Player has the specific non-class-specific reward

var player, rewardName;
player = argument0;
rewardName = argument1;

// No set of rewards
if (player.rewards == -1)
{
    return false;
}
else
{
    return ds_map_exists(player.rewards, rewardName);
}
