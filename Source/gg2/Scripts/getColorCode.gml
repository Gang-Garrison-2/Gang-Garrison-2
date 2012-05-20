// Returns a color indicated by a letter.
var color;

// I have no idea how to do this with color hex stings, and I'd be happy if someone could do it.
// So I just used this OHU code. -Orpheon

switch (string_copy(argument0, 0, 1))// Color code.
{
    case 'r':
        color = c_red;
        break;

    case 'b':
        color = make_color_rgb(0, 190, 255);// Lightblue, because c_blue looks like shit on a black background.
        break;
                
    case 'g':
        color = c_green;
        break;
                
    case 'w':
        color = c_white;
        break;
                
    case 's':// Black, because b is already taken. 's' because Schwarz.
        color = c_black;
        break;
                
    case 'y':
        color = make_color_rgb(90, 130, 180);
        break;
                
    case 'p':
        color = c_purple;
        break;
        
    case 'a':// Brown, had no idea so simply took a random letter
        color = make_color_rgb(190, 170, 100);
        break;
        
    case 'o':
        color = c_orange;
        break;
    
    default:
        color = c_white;
        break;
}

return color;
