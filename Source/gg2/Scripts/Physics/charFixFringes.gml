// Sets character speed depending on solidity of its immediate surrounding area.
// I forgot why this does each exact thing, but it's an important rectification.
var slopesize;
slopesize = 6;

if (ceil(iterspace-spent) == 0)
    break;

temp = (iterspace-spent)/ceil((iterspace-spent));

htest = cos(degtorad(direction))*temp;
vtest = -sin(degtorad(direction))*temp;

if(!place_free(x+htest, y) and !place_free(x+htest, y-slopesize) and !place_free(x+htest, y+slopesize))
{
    hspeed = 0;
    oldspace = iterspace;
    iterspace = point_distance(oldx_move, 0, x, olddy);
    x = round(x);
}
if(!place_free(x, y+sign(vspeed)))
{
    vspeed = 0;
    oldspace = iterspace;
    iterspace = point_distance(0, oldy_move, olddx, y);
    y = round(y);
}
if(!place_free(x+htest, y+vtest) and !place_free(x+htest, y-slopesize) and !place_free(x+htest, y+slopesize))
{
    if(place_free(x+htest, y))
    {
        vspeed = 0;
        oldspace = iterspace;
        iterspace = point_distance(0, oldy_move, olddx, y);
        y = round(y);
    }
    else
    {
        hspeed = 0;
        oldspace = iterspace;
        iterspace = point_distance(oldx_move, 0, x, olddy);
        x = round(x);
    }
}

