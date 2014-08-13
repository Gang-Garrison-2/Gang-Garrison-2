//Draws a progress bar on the screen.
//argument0: % done to display
//argument1: message to display

draw_healthbar(view_wport[0]/2-200,view_hport[0]/2-30,view_wport[0]/2+200,view_hport[0]/2+30,argument0,c_blue,c_green,c_green,0,true,true);
draw_set_halign(fa_center);
draw_set_color(c_black);
draw_text(view_wport[0]/2,view_hport[0]/2-10,argument1);
draw_text(view_wport[0]/2,view_hport[0]/2+10,string(argument0)+"%");

