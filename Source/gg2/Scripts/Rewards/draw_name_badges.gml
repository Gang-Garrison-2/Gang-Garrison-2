// void draw_name_badges(real x, real y, real player)
// Draws a player's name with bagdes, if any
// player is the ID of the Player object

var _x, _y, player;
_x = argument0;
_y = argument1;
player = argument2;

draw_set_valign(fa_top);
draw_set_halign(fa_left);

var i;
for (i = 0; i < global.HaxxyBadgesLength; i += 1)
{
    if (hasReward(player, global.HaxxyBadges[i])) {
        draw_sprite(HaxxyBadgeS, i, _x, _y - 1);
        _x += sprite_get_width(HaxxyBadgeS);
    }
}

draw_text(_x, _y, player.name);
