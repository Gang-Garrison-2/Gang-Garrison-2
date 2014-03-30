if instance_exists(WinBanner)
    exit;
draw_set_color(c_white);
//red timer HUD
draw_generictimer(xoffset-coffset+xshift, yoffset+36,        xsize, ysize, redTimer,  0, 1+(KothControlPoint.team == TEAM_RED) );
//blue timer HUD    
draw_generictimer(xoffset+coffset+xshift, yoffset+36+yshift, xsize, ysize, blueTimer, 1, 1+(KothControlPoint.team == TEAM_BLUE));
