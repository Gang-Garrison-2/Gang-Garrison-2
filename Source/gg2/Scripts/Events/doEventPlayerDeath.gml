/**
 * Perform the "player death" event, i.e. change the appropriate scores,
 * destroy the character object to much splattering and so on.
 *
 * argument0: The player whose character died
 * argument1: The player who inflicted the fatal damage (or noone for unknown)
 * argument2: The player who assisted the kill (or noone for no assist)
 * argument3: The source of the fatal damage
 */
var victim, killer, assistant, damageSource, killersForDomination;
victim = argument0;
killer = argument1;
assistant = argument2;
damageSource = argument3;
killersForDomination = ds_list_create();

if(!instance_exists(killer))
    killer = noone;

if(!instance_exists(assistant))
    assistant = noone;

//*************************************
//*      Scoring and Kill log
//*************************************
 

recordKillInLog(victim, killer, assistant, damageSource);

victim.stats[DEATHS] += 1;
if(killer)
{
    if(damageSource == DAMAGE_SOURCE_KNIFE || damageSource == DAMAGE_SOURCE_BACKSTAB)
    {
        killer.stats[STABS] += 1;
        killer.roundStats[STABS] += 1;
        killer.stats[POINTS] += 1;
        killer.roundStats[POINTS] +=1;
    }
    
    if (victim.object.currentWeapon.object_index == Medigun)
    {
        if (victim.object.currentWeapon.uberReady)
        {
            killer.stats[BONUS] += 1;
            killer.roundStats[BONUS] += 1;
            killer.stats[POINTS] += 1;
            killer.roundStats[POINTS] += 1;
        }
    }
        
    if (killer != victim)
    {
        killer.stats[KILLS] += 1;
        killer.roundStats[KILLS] += 1;
        killer.stats[POINTS] += 1;
        killer.roundStats[POINTS] += 1;
        if(victim.object.intel)
        {
            killer.stats[DEFENSES] += 1;
            killer.roundStats[DEFENSES] += 1;
            killer.stats[POINTS] += 1;
            killer.roundStats[POINTS] += 1;
            recordEventInLog(4, killer.team, killer.name, global.myself == killer);
        }

        ds_list_add(killersForDomination, killer);
    }
}

if (assistant)
{
    assistant.stats[ASSISTS] += 1;
    assistant.roundStats[ASSISTS] += 1;
    assistant.stats[POINTS] += .5;
    assistant.roundStats[POINTS] += .5;

    ds_list_add(killersForDomination, assistant);
}

var i, killerForDomination;
for (i = 0; i < ds_list_size(killersForDomination); i += 1)
{
    killerForDomination = ds_list_find_value(killersForDomination, i);

    if (domination_kills_get(victim.dominationKills, killerForDomination) > 3)
    {
        recordDominationInLog(victim, killerForDomination, 1);
    }
    else if (domination_kills_get(killerForDomination.dominationKills, victim) == 3)
    {
        recordDominationInLog(victim, killerForDomination, 0);
    }
    domination_kills_increase(killerForDomination.dominationKills, victim);
    domination_kills_delete(victim.dominationKills, killerForDomination);
}

ds_list_destroy(killersForDomination);

//SPEC
if (victim == global.myself)
    instance_create(victim.object.x, victim.object.y, Spectator);

//*************************************
//*         Gibbing
//*************************************
var xoffset, yoffset, xsize, ysize;

xoffset = view_xview[0];
yoffset = view_yview[0];
xsize = view_wview[0];
ysize = view_hview[0];

randomize();
with(victim.object) {
    var hasTombstone, diedOfExplosion, gibsWhenExploded, isCloseBy;
    hasTombstone = (victim.class != CLASS_QUOTE) and hasClassReward(victim, 'Tombstone_');
    diedOfExplosion = damageSource == DAMAGE_SOURCE_ROCKETLAUNCHER
        or damageSource == DAMAGE_SOURCE_MINEGUN
        or damageSource == DAMAGE_SOURCE_FRAG_BOX
        or damageSource == DAMAGE_SOURCE_REFLECTED_STICKY
        or damageSource == DAMAGE_SOURCE_REFLECTED_ROCKET
        or damageSource == DAMAGE_SOURCE_FINISHED_OFF_GIB
        or damageSource == DAMAGE_SOURCE_GENERATOR_EXPLOSION;
    gibsWhenExploded = (player.class != CLASS_QUOTE) and (global.gibLevel>1);
    isCloseBy = distance_to_point(xoffset+xsize/2,yoffset+ysize/2) < 900;

    if(diedOfExplosion and gibsWhenExploded)
    {
        playsound(x,y,Gibbing);
        if(isCloseBy) // Performance optimization, since gibs are somewhat expensive
        {
            if (hasReward(victim, 'PumpkinGibs'))
            {
                repeat(global.gibLevel * 2)
                {
                    createGib(x,y,PumpkinGib,hspeed,vspeed,random(145)-72, choose(0,1,1,2,2,3), false)
                }
            }
            else
            {
                repeat(global.gibLevel)
                {
                    createGib(x,y,Gib,hspeed,vspeed,random(145)-72, 0, false)
                }
                switch(player.team)
                {
                case TEAM_BLUE :
                    repeat(global.gibLevel - 1)
                    {
                        createGib(x,y,BlueClump,hspeed,vspeed,random(145)-72, 0, false)
                    }
                    break;
                case TEAM_RED :
                    repeat(global.gibLevel - 1)
                    {
                        createGib(x,y,RedClump,hspeed,vspeed,random(145)-72, 0, false)
                    }
                    break;
                }
            }

            repeat(global.gibLevel * 14)
            {
                var blood;
                blood = instance_create(x+random(23)-11,y+random(23)-11,BloodDrop);
                blood.hspeed=(random(21)-10);
                blood.vspeed=(random(21)-13);
                if (hasReward(victim, 'PumpkinGibs'))
                {
                    blood.sprite_index = PumpkinJuiceS;
                }
            }

            if (!hasReward(victim, 'PumpkinGibs'))
            {
                //All Classes gib head, hands, and feet
                if(global.gibLevel > 2 || choose(0,1) == 1)
                    createGib(x,y,Headgib,0,0,random(105)-52, player.class, false);

                repeat(global.gibLevel -1)
                {
                    //Medic has specially colored hands
                    if (player.class == CLASS_MEDIC)
                    {
                        if (player.team == TEAM_RED)
                            createGib(x,y,Hand, hspeed, vspeed, random(105)-52 , 9, false);
                        else
                            createGib(x,y,Hand, hspeed, vspeed, random(105)-52 , 10, false);
                    }
                    else
                    {
                        createGib(x,y,Hand, hspeed, vspeed, random(105)-52 , player.class, false);
                    }
                    createGib(x,y,Feet,random(5)-2,random(3),random(13)-6 , player.class, true);
                }
            }

            //Class specific gibs
            switch(player.class) {
            case CLASS_PYRO :
                if(global.gibLevel > 2 || choose(0,1) == 1)
                    createGib(x,y,Accesory,hspeed,vspeed,random(105)-52, 4, false)
                break;
            case CLASS_SOLDIER :
                if(global.gibLevel > 2 || choose(0,1) == 1)
                {
                    switch(player.team)
                    {
                        case TEAM_BLUE :
                            createGib(x,y,Accesory,hspeed,vspeed,random(105)-52, 2, false);
                            break;
                        case TEAM_RED :
                            createGib(x,y,Accesory,hspeed,vspeed,random(105)-52, 1, false);
                            break;
                    }
                }
                break;
            case CLASS_ENGINEER :
                if(global.gibLevel > 2 || choose(0,1) == 1)
                    createGib(x,y,Accesory,hspeed,vspeed,random(105)-52, 3, false)
                break;
            case CLASS_SNIPER :
                if(global.gibLevel > 2 || choose(0,1) == 1)
                    createGib(x,y,Accesory,hspeed,vspeed,random(105)-52, 0, false)
                break;
            }
        }
    }
    else
    {
        var deadbody;
        if (player.class != CLASS_QUOTE)
            playsound(x,y,choose(DeathSnd1, DeathSnd2));

        deadbody = instance_create(x,y-30,DeadGuy);
        // 'GS' reward - *G*olden *S*tatue
        if(hasReward(player, 'GS'))
        {
            deadbody.sprite_index = haxxyStatue;
            deadbody.image_index = 0;
        }
        else
        { 
            deadbody.sprite_index = spriteDead;
            deadbody.image_index = 0;
        }
        deadbody.hspeed=hspeed;
        deadbody.vspeed=vspeed;
        if(hspeed>0)
        {
            deadbody.image_xscale = -1;  
        }
        if(hasClassReward(victim, "DeathMoney_"))
            deadbody.hasMoney = true;
        player.corpse = deadbody;
    }

    if(hasTombstone)
    {
        global.paramCharacter = id;
        instance_create(x, y, Tombstone);
    }
}

if (victim.object.has_crown) {
    myHat = instance_create(victim.object.x,victim.object.y,CrownGib);
    myHat.image_index = victim.team;
}
if (victim.object.has_navigatorhat) {
    myHat = instance_create(victim.object.x,victim.object.y,NavigatorHatGib);
    myHat.image_index = victim.team;
}
if (victim.object.has_partyhat){
    myHat = instance_create(victim.object.x,victim.object.y,PartyHat);
    myHat.image_index = victim.team;
}
if (global.xmas){
    myHat = instance_create(victim.object.x,victim.object.y,XmasHat);
    myHat.image_index = victim.team;
}

if (hasReward(victim, 'Ghost') and victim.ghost == noone) {
    victim.ghost = instance_create(victim.object.x, victim.object.y, Ghost);
    victim.ghost.owner = victim;
    victim.ghost.hspeed = hspeed;
    victim.ghost.vspeed = vspeed;
}

with(victim.object) {       
    instance_destroy();
}

//*************************************
//*         Deathcam
//*************************************
if( global.killCam and victim == global.myself and killer and killer != victim and !(damageSource == DAMAGE_SOURCE_KILL_BOX || damageSource == DAMAGE_SOURCE_FRAG_BOX || damageSource == DAMAGE_SOURCE_FINISHED_OFF || damageSource == DAMAGE_SOURCE_FINISHED_OFF_GIB || damageSource == DAMAGE_SOURCE_GENERATOR_EXPLOSION)) {
    instance_create(0,0,DeathCam);
    DeathCam.killedby=killer;
    DeathCam.name=killer.name;
    DeathCam.oldxview=view_xview[0];
    DeathCam.oldyview=view_yview[0];
    DeathCam.lastDamageSource=damageSource;
    DeathCam.team = global.myself.team;
}

// Gamemode considerations
if (instance_exists(TeamDeathmatchHUD) and killer and killer != victim)
{
    if (killer.team != victim.team)
    {
        if (killer.team == TEAM_RED)
            global.redCaps += 1;
        else if (killer.team == TEAM_BLUE)
            global.blueCaps += 1;
    }
}
