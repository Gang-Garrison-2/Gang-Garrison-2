/**
 * Draws a healthbar for HealthHud and SentryHealthHud
 * Arguments: drawHealth(x,y,hp,maxHp)
 * x/y-Position is the top left of the drawn health bar
 */
var xoffset, yoffset, xsize, ysize, xpos, ypos, hp, maxHp;
xoffset = view_xview[0];
yoffset = view_yview[0];
xsize = view_wview[0];
ysize = view_hview[0];

xpos = argument0;
ypos = argument1;
hp = argument2;
maxHp = argument3;

draw_set_valign(fa_center);
draw_set_halign(fa_center);
draw_set_alpha(1);
draw_healthbar(xoffset+xpos, yoffset+ypos, xoffset+xpos+42, yoffset+ypos+37, hp*100/maxHp, c_black, c_red, c_green, 3, true, false);

var hpText,hpColor;
if(hp > (maxHp/3.5)) {
    hpColor = c_white;
} else  {
    hpColor = c_red;
}

hpText = string(ceil(max(hp,0)));

draw_text_color(xoffset+xpos+24, yoffset+ypos+18, hpText, hpColor, hpColor, hpColor, hpColor, 1);
