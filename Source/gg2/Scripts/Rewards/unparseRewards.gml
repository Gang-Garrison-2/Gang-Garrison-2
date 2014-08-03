// string unparseRewards(real rewards)
// Produces rewardString from rewards ds_map serving as set

var rewards;
rewards = argument0;

var rewardString, reward;
rewardString = '';

for (reward = ds_map_find_first(rewards); is_string(reward); reward = ds_map_find_next(rewards, reward))
{
    if (reward != ds_map_find_first(rewards))
        rewardString += ':';
    rewardString += reward;
}

return rewardString;
