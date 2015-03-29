//createShot(x, y, projectile, damageSource, direction, projectileSpeed)

var _x, _y, projectile, damageSource, dir, projectileSpeed, shot;
_x = argument0;
_y = argument1;
projectile = argument2;
damageSource = argument3;
dir = argument4;
projectileSpeed = argument5;

shot = instance_create(_x,_y,projectile);
shot.direction=dir;
shot.image_angle = shot.direction;
shot.speed=projectileSpeed;
shot.owner=owner;
shot.ownerPlayer=ownerPlayer;
shot.team=owner.team;
shot.weapon=damageSource;
return shot;
