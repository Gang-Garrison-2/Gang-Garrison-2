// real name_width_badges(real player)
// Returns the width that a player's name with badges would take up

var player;
player = argument0;

return string_width(player.name) + (sprite_get_width(HaxxyBadgeS) * ds_list_size(player.badges));
