// real parseRewards(string rewardString)
// Parses rewardString and returns a ds_map serving as a set of rewards
// or -1 if none

var rewardString;
rewardString = argument0;

if (rewardString == '')
    return -1;

var rewardList, i, rewardSet;
rewardList = split(rewardString, ':');
rewardSet = ds_map_create();
for (i = 0; i < ds_list_size(rewardList); i += 1)
{
    ds_map_add(rewardSet, ds_list_find_value(rewardList, i), 0);
}
ds_list_destroy(rewardList);

return rewardSet;
