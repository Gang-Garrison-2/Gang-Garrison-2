// Moves the character which calls it, accounting for solid objects and physics.

slopesize = 6;
slopespent = 0;
spent = 0;
remainingx = abs(hspeed);
remainingy = abs(vspeed);
olddx = hspeed;
olddy = vspeed;
olddir = direction;
oldx_move = x;
oldy_move = y;
tempx_move = x;
tempy_move = y;

while(remainingx > 0 or remainingy > 0)
{
    tempx_move = x;
    tempy_move = y;
    tempdir_move = direction;
    
    onground = !place_free(x, y+1);
    
    move_contact_solid(direction, min(slopesize, point_distance(0, 0, remainingx, remainingy)));
    
    remainingx -= abs(x-tempx_move);
    remainingy -= abs(y-tempy_move);
    
    hspeedpart = crop1(hspeed);
    vspeedpart = crop1(vspeed);
    
    // GM function calls are fucking expensive: cache them
    step_free = place_free(x, y+slopesize);
    step_there = !place_free(x, y+slopesize+1);
    
    do // bluh I really want goto right here but I have to use a loop instead
    {
        if(onground and step_free and step_there and vspeed >= 0) // valid downward slope 
        {
            remainingy = 0;
            y = round(y);
            y += slopesize;
            break;
        }
        
        floor_free = place_free(x, y+1); // makeshift caching for collision operations
        here_free = place_free(x, y);
        ongroundnew = here_free and !floor_free;
        generally_free = place_free(x+hspeedpart, y+vspeedpart);
        
        if(generally_free and !ongroundnew) // immediate area is clear (do nothing this iteration)
        {
            break;
        }
        
        slope_free = place_free(x+hspeedpart, y-slopesize);
        strafe_free = place_free(x+hspeedpart, y);
        
        if(!strafe_free and slope_free) // valid upward slope
        {
            y -= slopesize;
            break;
        }
        
        slide_free = place_free(x+hspeedpart, y+slopesize);
        
        if(!strafe_free and slide_free) // valid ceiling slope
        {
            y += slopesize;
            break;
        }
        
        ballistic_free = place_free(x, y+vspeedpart);
        
        if(strafe_free and !ballistic_free) // ceiling/floor (apparently)
        {
            remainingy = 0;
            y = round(y);
            vspeed = 0;
            break;
        }
        if(!strafe_free and ballistic_free) // wall (apparently)
        {
            remainingx = 0;
            x = round(x);
            hspeed = 0;
            break;
        }
        if(!strafe_free and !ballistic_free) // stuck (apparently)
        {
            remainingx = 0;
            remainingy = 0;
            x = round(x);
            y = round(y);
            speed = 0;
            break;
        }
        if(strafe_free and ballistic_free and !generally_free) // hit a corner with my corner (apparently) (treat this like a floor/ceiling)
        {
            remainingy = 0;
            y = round(y);
            vspeed = 0;
            break;
        }
    } until(1)
    if(tempx_move == x and tempy_move == y and tempdir_move == direction) // loop detection / breakage
        break;
}

// Set these backwards before the game runs step
x -= hspeed;
y -= vspeed;

