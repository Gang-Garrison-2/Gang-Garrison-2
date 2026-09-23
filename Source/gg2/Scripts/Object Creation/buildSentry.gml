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
    // TODO(enigma): temp var avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
    var playerSentry;
    playerSentry = player.sentry;
    playerSentry.x = xPos;
    playerSentry.y = yPos;
}

// TODO(enigma): temp var avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
var sentryInst;
sentryInst = player.sentry;
sentryInst.startDirection = startDirection;
sentryInst.image_xscale = startDirection;
player.object.nutsNBolts -= 100;
