// real name_width_badges(real player)
// Returns the width that a player's name with badges would take up

var player;
player = argument0;

var width, i;
width = 0;
for (i = 0; i < global.HaxxyBadgesLength; i += 1)
{
    if (hasReward(player, global.HaxxyBadges[i])) {
        width += sprite_get_width(HaxxyBadgeS);
    }
}

width += string_width(player.name);

return width;
