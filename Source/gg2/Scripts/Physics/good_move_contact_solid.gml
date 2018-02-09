// An accurate reimplementation of move_contact_solid.

// Move our position by a movement vector until we hit a solid object or we finish the movement's magnitude.

if(argument1 <= 0)
    return 0;

var i, MAX_I, maxDistance, hvec, vvec, sfac, moveX, moveY, totalMoved;

MAX_I = 8; // subpixel precision (MAX_I = 8 means 1/8th of a pixel)
i = 8;

maxDistance = argument1; // max distance alotted
hvec = cos(degtorad(argument0))*maxDistance;  // h vector of direction
vvec = -sin(degtorad(argument0))*maxDistance; // v '''
sfac = max(abs(hvec), abs(vvec)); // Used to get pixel chunks from the movement vector
totalMoved = 0;
global.lastCollisionHappened = false;

while ( totalMoved < maxDistance and i > 0 )
{
    var newx, newy;
    moveX = hvec/sfac * i/MAX_I * min(1, maxDistance - totalMoved);
    moveY = vvec/sfac * i/MAX_I * min(1, maxDistance - totalMoved);

    newx = x + moveX*i/MAX_I;
    newy = y + moveY*i/MAX_I;
    if (place_free(newx, newy))
    {
        totalMoved += point_distance(x, y, newx, newy);
        x = newx;
        y = newy;
        if(i < MAX_I) // Finished crawling backwards out of whatever we hit
            break;
    }
    else
    {
        global.lastCollisionHappened = true;
        global.lastCollisionX = newx;
        global.lastCollisionY = newy;
        i -= 1; // Crawl backwards by subpixels if we hit something
    }
}

return totalMoved;

