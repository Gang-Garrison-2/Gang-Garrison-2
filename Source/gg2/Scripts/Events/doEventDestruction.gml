/**
 * Perform the "building destroyed" event, i.e. change the appropriate scores,
 * destroy the building object to spawn metal and so on.
 *
 * argument0: The player whose building died
 * argument1: The player who inflicted the fatal damage (or -1 for self)
 * argument2: The healer who assisted the destruction (or -1 for no assist)
 * argument3: The source of the fatal damage
 */
var owner, killer, assistant, damageSource;
owner = argument0;
killer = argument1;
healer = argument2;
damageSource = argument3;
 
//*************************************
//*      Scoring and Kill log
//*************************************
 
//victim.deaths += 1;
if(killer != -1 && killer != owner) {
    killer.stats[DESTRUCTION] +=1;
    killer.roundStats[DESTRUCTION] +=1;
    killer.stats[POINTS] += 1;
    killer.roundStats[POINTS] += 1;
    recordDestructionInLog(owner, killer, healer, damageSource);
    setChatBubble(owner, 60)
}
//*************************************
//*         Scrapped
//*************************************
with(owner.sentry) {
    instance_destroy();
}
    /*if built==1 {
        with(currentWeapon) {
            instance_destroy();
        }
    }
    if global.myself == owner {
        if !instance_exists(NoticeO) instance_create(0,0,NoticeO);
        with NoticeO notice = NOTICE_AUTOGUNSCRAPPED;
    }

    // Allow the mines stickied to this autogun to drop to the floor
    with(Mine) {
        if(place_meeting(x,y,other.id)) {
            stickied = false;
        }
    }
    
    ownerPlayer.sentry=-1;
    instance_create(x,y,Explosion)
    playsound(x,y,ExplosionSnd);
    sentrygibs=instance_create(x,y,SentryGibs);
    sentrygibs.image_speed=0;
    if team == TEAM_RED sentrygibs.image_index=0;
    else sentrygibs.image_index=1;
}*/
//end

/*with(owner.sentry) {       
    instance_destroy();
}*/
