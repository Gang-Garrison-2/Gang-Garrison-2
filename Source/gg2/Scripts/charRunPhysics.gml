// Moves the character which calls it, accounting for solid objects and physics.

slopesize = 6;
slopespent = 0;
iters = ceil(speed);
iterspace = speed;
spent = 0;
olddx = hspeed;
olddy = vspeed;
olddir = direction;
oldx_move = x;
oldy_move = y;

if(speed < 0.195)
    status = "still";

while(spent < iterspace and iterspace != 0 and speed != 0)
{
    itersize = (iterspace-spent)/ceil((iterspace-spent)) * global.collisionAccuracy;
    
    xd =  cos(degtorad(direction))*itersize;
    yd = -sin(degtorad(direction))*itersize;
    
    if(place_free(x+xd, y+yd))
    {
        // walk down slopes
        if(     place_free(x+xd, y+1)
           and !place_free(x,    y+1)
           and !place_free(x+xd, y+slopesize+1)
           and vspeed >= 0)
        {
            status = "downslope";
            x += xd;
            y += slopesize;
            slopespent += slopesize;
            spent += abs(xd);
            
            vspeed = 0;
            y = round(y);
            charFixFringes();
        }
        // purely in air
        else
        {
            status = "air";
            x += xd;
            y += yd;
            charFixFringes();
            spent += itersize;
        }
    }
    else // place_free(x+xd, y+yd) false
    {
        // normal up-slope
        if(place_free(x+xd, y-slopesize))
        {
            status = "slope";
            x += xd;
            y -= slopesize;
            slopespent -= slopesize;
            spent += abs(xd);
            
            vspeed = min(0, vspeed);
            y = round(y);
            charFixFringes();
        }
        // slope down sloped ceilings
        else if(place_free(x+xd, y+slopesize))
        {
            status = "ceilslope";
            x += xd;
            y += slopesize;
            slopespent += slopesize;
            spent += abs(xd);
            
            vspeed = max(0, vspeed);
            y = round(y);
            charFixFringes();
        }
        // ceiling/floor (apparently)
        else if(place_free(x+xd, y))
        {
            status = "ceil";
            x += xd;
            spent += abs(xd);
            
            vspeed = 0;
            charFixFringes();
            
            y = round(y);
        }
        // wall (apparently)
        else if(place_free(x, y+yd))
        {
            status = "wall";
            y += yd;
            spent += abs(yd);
            
            hspeed = 0;
            charFixFringes();
            
            x = round(x);
        }
        // inside of obstacle (from what we can tell)
        else
        {
            status = "stuck";
            x = round(x);
            y = round(y);
            speed = 0;
            charFixFringes();
        }
    }
}

// Set these backwards before the game runs step
x -= hspeed;
y -= vspeed;

