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
/*
if (overtime)
{
    draw_set_halign(fa_center);
    draw_sprite_ext(TimerHudS,2+teamoffset,xoffset+xsize/2+xshift,yoffset+30+ yshift,3,3,0,c_white,1);
    draw_text((xoffset+xsize/2)+xshift,yoffset+30+yshift,"OVERTIME");
}
else
{
    draw_set_halign(fa_right);
    draw_sprite_ext(TimerHudS,teamoffset,xoffset+xsize/2 +xshift,yoffset+30+ yshift,3,3,0,c_white,1);
    draw_sprite_ext(TimerS,floor(timer/timeLimit*12),xoffset+xsize/2+39 +xshift,yoffset+30+ yshift,3,3,0,c_white,1);
    
    var time, minutes, secondcounter, seconds, secstring;
    minutes = floor(timer/1800);
    secondcounter = timer-minutes*1800;
    seconds = floor(secondcounter/30);
    draw_set_font(global.timerFont);
    
    if (seconds >= 10)
        secstring = string(seconds);
    else
        secstring = "0" + string(seconds);
        
    draw_text_transformed(xoffset+xsize/2+20+xshift,yoffset+32+yshift,string(minutes) + ":" + secstring,1,1,0);
    draw_set_font(global.gg2Font);
}*/
