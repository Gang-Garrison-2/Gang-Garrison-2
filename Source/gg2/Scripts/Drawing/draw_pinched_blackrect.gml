// a[0]: x
//   1 : y
//   2 : width
//   3 : height
//   4 : inset (dimensions of squares removed from corners)
//   5 : bezel? (whether to draw the bezel effect)

var x1, x2, x3, x4, y1, y2, y3, y4, dampen;
x1 = argument0;
x2 = x1+argument4;
x3 = x1+argument2-argument4-1;
x4 = x1+argument2-1;
y1 = argument1;
y2 = y1+argument4;
y3 = y1+argument3-argument4-1;
y4 = y1+argument3-1;
// main body
if(argument5 > 1)
    draw_set_alpha(sqr(draw_get_alpha()));
draw_rectangle(x1, y2,      x4, y3,   false); // main segment (without top and bottom past inset)
if (argument4 > 0)
{
    draw_rectangle(x2,   y1,   x3, y2-1, false); // top half
    draw_rectangle(x2,   y3+1, x3, y4,   false); // bottom half
}
if(argument5 > 1)
    draw_set_alpha(sqrt(draw_get_alpha()));
// bezel 
if(argument5 > 0 and argument5 < 3)
{
    draw_rectangle(x2, y4, x3, y4, false); // bottom middle
    draw_rectangle(x4, y2, x4, y3, false); // right middle
    if (argument4 > 0)
    {
        draw_rectangle(x1,   y3, x2-1, y3, false); // bottom left
        draw_rectangle(x3+1, y3, x4-1, y3, false); // bottom right
        draw_rectangle(x3, y1, x3, y2-1, false); // right top
        draw_rectangle(x3, y3, x3, y4-1, false); // right bottom
    }
}

