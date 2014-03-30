var xoffset, yoffset, xsize, ysize, xshift, yshift;
xoffset = argument0;
yoffset = argument1;
xsize = argument2;
ysize = argument3;
xshift = -320*global.timerPos;
yshift = 5*global.timerPos;

if instance_exists(WinBanner)
    exit;

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_center);

if (global.myself != -1)
{
    if (global.myself.team == TEAM_RED)
        teamoffset = 0;
    else if (global.myself.team == TEAM_BLUE)
        teamoffset = 1;
}

draw_generictimer(xoffset+xshift, yoffset+yshift, xsize, ysize, argument4, argument5, 0);
