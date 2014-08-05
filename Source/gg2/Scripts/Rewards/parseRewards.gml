// real parseRewards(string rewardString, [out] real rewardSet)
// Parses rewardString and uses the information to fill the rewardSet, which is a ds_map serving as a set of rewards
// The previous content of rewardSet will be replaced.

var rewardString, rewardSet;
rewardString = argument0;
rewardSet = argument1;

ds_map_clear(rewardSet);

var rewardList, i;
rewardList = split(rewardString, ':');
for (i = 0; i < ds_list_size(rewardList); i += 1)
{
    ds_map_add(rewardSet, ds_list_find_value(rewardList, i), 0);
}
ds_list_destroy(rewardList);
