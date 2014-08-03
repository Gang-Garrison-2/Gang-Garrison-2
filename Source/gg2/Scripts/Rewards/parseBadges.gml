// real parseBadges(real rewards, [out] real badges)
// Takes a reward ds_map and uses it to fill the badges ds_list with the numerical IDs of all the badges.
// The old content of the badges list will be replaced.

var rewards, badges;
rewards = argument0;
badges = argument1;

ds_list_clear(badges);

var i;
for (i = 0; i < global.HaxxyBadgesLength; i += 1)
{
    if (ds_map_exists(rewards, global.HaxxyBadges[i])) {
        ds_list_add(badges, i);
    }
}
