var player, xPos, yPos, startDirection;

player = argument0;
xPos = argument1;
yPos = argument2;
startDirection = argument3;

if(!player.sentry)
{
    player.sentry = instance_create(xPos, yPos, Sentry);
    player.sentry.ownerPlayer = player;
    player.sentry.team = player.team;
}
else
{
    player.sentry.x = xPos;
    player.sentry.y = yPos;
}

player.sentry.startDirection = startDirection;
player.sentry.image_xscale = startDirection;
player.object.nutsNBolts -= 100;
