if instance_exists(argument0) {
    if(argument0.object != -1) {
    if argument0.class == CLASS_ENGINEER && argument0.object.sentryBuilt ==0 {
        with(argument0.object){
        sentryBuilt=1;
        sentry = instance_create(x+3*argument0.object.image_xscale,y,Sentry);
        sentry.owner=argument0.object.id;
        sentry.ownerPlayer=argument0;
        sentry.team=argument0.team;
        sentry.image_xscale=image_xscale;
       
        }

        }
    }
}


/*if(instance_exists(argument0)) {
    if(argument0.object != -1) {
        argument0.object.bubbleImage=argument1;
        argument0.object.alarm[0] = 60;
        argument0.object.bubbleAlpha = 1;
        argument0.object.bubbleFadeout = false;
    }
}*/