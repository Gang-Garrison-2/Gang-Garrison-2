// void draw_name_badges(real x, real y, real player, alpha)
// Draws a player's name with badges, if any
// player is the ID of the Player object

var _x, _y, player, alpha, prevalpha;
_x = argument0;
_y = argument1;
player = argument2;
alpha = argument3
prevalpha = draw_get_alpha();

draw_set_valign(fa_top);
draw_set_halign(fa_left);

var i;
for (i = 0; i < ds_list_size(player.badges); i += 1)
{
    //seems a bit overkill but its the easiest way to do draw_sprite transparency from what i can gather
    draw_sprite_ext(HaxxyBadgeS, ds_list_find_value(player.badges, i) ,_x, _y - 1, 1, 1, 0, c_white, alpha);
    _x += sprite_get_width(HaxxyBadgeS);
}

draw_set_alpha(alpha);
draw_text(_x, _y, player.name);
draw_set_alpha(prevalpha);
