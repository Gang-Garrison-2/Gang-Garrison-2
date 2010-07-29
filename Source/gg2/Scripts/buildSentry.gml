if instance_exists(argument0) {
    argument0.sentry = instance_create(argument0.object.x,argument0.object.y,Sentry);
    argument0.sentry.ownerPlayer = argument0;
    argument0.sentry.team = argument0.team;
    argument0.sentry.startDirection = argument0.object.image_xscale;
    argument0.sentry.image_xscale = argument0.object.image_xscale;
    argument0.object.nutsNBolts -= 100;
}
