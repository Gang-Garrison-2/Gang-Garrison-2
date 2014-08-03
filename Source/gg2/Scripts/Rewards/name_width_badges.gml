// real name_width_badges(real player)
// Returns the width that a player's name with badges would take up

var player;
player = argument0;

var width, i;
if (player.badges != -1)
    width = sprite_get_width(HaxxyBadgeS) * ds_list_size(player.badges);
else
    width = 0;

width += string_width(player.name);

return width;
