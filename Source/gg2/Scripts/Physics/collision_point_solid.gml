//collision_point_solid(x, y);
instance_create(argument0, argument1, Point);
var collide;
with(Point)
{
    collide = !place_free(x, y);
    instance_destroy();
}
return collide;

