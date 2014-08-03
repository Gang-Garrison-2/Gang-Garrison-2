// real parseBadges(real rewards)
// Takes a reward map and returns a list of numerical badge IDs

var rewards;
rewards = argument0;

var badges;
badges = ds_list_create();

var i;
for (i = 0; i < global.HaxxyBadgesLength; i += 1)
{
    if (ds_map_exists(rewards, global.HaxxyBadges[i])) {
        ds_list_add(badges, i);
    }
}

return badges;
