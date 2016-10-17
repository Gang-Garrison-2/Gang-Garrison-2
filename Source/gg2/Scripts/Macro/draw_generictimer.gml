var xoffset, yoffset, xsize, ysize, countdown, mode;
xoffset = argument0;
yoffset = argument1;
xsize = argument2;
ysize = argument3;
countdown = argument4;
teamoffset = argument5;
mode = argument6; // 0: normal, large; 1: normal, small; 2: outlined, small

// note about "magic number" 1800, used below:
// 1800=60*30, where 60 is the number of seconds in a minute, and 30 is tickrate

if (mode == 0)
{
    if (overtime)
    {
        draw_set_halign(fa_center);
        draw_sprite_ext(TimerHudS,2+teamoffset,xoffset+xsize/2,yoffset+30,3,3,0,c_white,1);
        draw_text((xoffset+xsize/2)+xshift,yoffset+30+yshift,"OVERTIME");
    }
    else
    {
        draw_sprite_ext(TimerHudS,teamoffset,xoffset+xsize/2,yoffset+30,3,3,0,c_white,1);
        draw_set_halign(fa_right);
        draw_set_font(global.timerFont);
        
        var isControlPointSetup, ticks, ticklimit, timeYOff, totalSeconds, minutes, seconds, secstring;
        isControlPointSetup = global.setupTimer > 0 and instance_exists(ControlPointSetupGate);
        if(isControlPointSetup)
        {
            ticks = global.setupTimer;
            ticklimit = 1800;
            timeYOff = 27;
        }
        else
        {
            ticks = countdown;
            ticklimit = timeLimit;
            timeYOff = 32;
        }
        draw_sprite_ext(TimerS,floor(12*ticks/ticklimit),xoffset+xsize/2+39,yoffset+30,3,3,0,c_white,1);
        totalSeconds = ceil(ticks/30);
        minutes = totalSeconds div 60;
        seconds = totalSeconds mod 60;
        if (seconds >= 10)
            secstring = string(seconds);
        else
            secstring = "0" + string(seconds);
        
        draw_text_transformed(xoffset+xsize/2+20,yoffset+timeYOff,string(minutes) + ":" + secstring,1,1,0);
        
        draw_set_font(global.gg2Font);
        
        if(isControlPointSetup)
        {
            draw_set_halign(fa_center);
            draw_text_transformed(xoffset+xsize/2-3, yoffset+40,"Setup",1,1,0);
        }
    }
}
else
{
    if (mode == 2)
        draw_sprite_ext(TimerOutlineS, 0, xoffset+xsize/2, yoffset, 2, 2, 0, c_white, 1);
    draw_sprite_ext(TimerHudS, 2+teamoffset, xoffset+xsize/2+xshift, yoffset, 2,2,0,c_white,1);
    if (countdown <= 0)
    {
        draw_set_halign(fa_center);
        draw_text(xoffset+xsize/2+xshift,yoffset+2,"OVERTIME");
    }
    else
    {
        draw_set_halign(fa_right);
        var time, minutes, secondcounter, seconds, secstring;
        secondcounter = ceil(countdown/30);
        minutes = secondcounter div 60;
        seconds = secondcounter mod 60;
        draw_set_font(global.timerFont);
        
        if (seconds >= 10)
            secstring = string(seconds);
        else
            secstring = "0" + string(seconds);
            
        draw_text_transformed(xoffset+xsize/2+24, yoffset+2, string(minutes) + ":" + secstring, 1, 1, 0);
        draw_set_font(global.gg2Font);
    }
}
