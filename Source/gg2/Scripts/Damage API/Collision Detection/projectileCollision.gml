// projectileCollision( sourcePlayer, damagedCharacter, damageDealt, projectile, blood, explosion)
// note: meant only for Character interactions
var shootingPlayer,shotCharacter,damage,projectile,blood,explosion;
shootingPlayer = argument0;
shotCharacter = argument1;
damage = argument2;
projectile = argument3;
blood = argument4;

damageCharacter(shootingPlayer, shotCharacter.id, damage, projectile);

{
    if (projectile.object_index == Rocket)
    {
        if (shotCharacter.id == shootingPlayer.object and instance_exists(shotCharacter.lastDamageDealer) and shotCharacter.lastDamageDealer != shootingPlayer)
            shotCharacter.lastDamageSource = DAMAGE_SOURCE_FINISHED_OFF_GIB;
        else
        {
            if (shotCharacter.lastDamageDealer != shootingPlayer and 
                shotCharacter.lastDamageDealer != shotCharacter.player)
            {
                shotCharacter.secondToLastDamageDealer = shotCharacter.lastDamageDealer;
                shotCharacter.alarm[4] = shotCharacter.alarm[3]
            }
            shotCharacter.alarm[3] = ASSIST_TIME / global.delta_factor;
            shotCharacter.lastDamageDealer = shootingPlayer;
            shotCharacter.lastDamageSource = projectile.weapon;
        }  
    }
    else if (projectile.object_index == Mine)
    {
        if (shotCharacter.id == shootingPlayer.object and instance_exists(shotCharacter.lastDamageDealer) and shotCharacter.lastDamageDealer != shootingPlayer and !instance_exists(projectile.reflector))
            shotCharacter.lastDamageSource = DAMAGE_SOURCE_FINISHED_OFF_GIB;
        else
        {
            if (shotCharacter.lastDamageDealer != shootingPlayer and shotCharacter.lastDamageDealer != shotCharacter.player and projectile.reflector != shotCharacter.lastDamageDealer)
            {
                secondToLastDamageDealer = lastDamageDealer;
                alarm[4] = alarm[3]
            }
            if (shootingPlayer != shotCharacter.id or (instance_exists(projectile.reflector) and shootingPlayer == id))
                alarm[3] = ASSIST_TIME / global.delta_factor;
            shotCharacter.lastDamageDealer = shootingPlayer;
            if (shotCharacter.id==shootingPlayer.object and instance_exists(projectile.reflector))
            {
                lastDamageDealer = projectile.reflector;
                lastDamageSource = DAMAGE_SOURCE_REFLECTED_STICKY;
            }
        }           
    } else {
        if (shotCharacter.lastDamageDealer != shootingPlayer and 
            shotCharacter.lastDamageDealer != shotCharacter.player)
        {
            shotCharacter.secondToLastDamageDealer = shotCharacter.lastDamageDealer;
            shotCharacter.alarm[4] = shotCharacter.alarm[3]
        }
        shotCharacter.alarm[3] = ASSIST_TIME / global.delta_factor;
        shotCharacter.lastDamageDealer = shootingPlayer;
        if (projectile.object_index == StabMask) 
        {
            if sign(other.image_xscale) == sign(image_xscale)
                other.lastDamageSource = DAMAGE_SOURCE_BACKSTAB;
            else
                other.lastDamageSource = DAMAGE_SOURCE_KNIFE;
        } else
        shotCharacter.lastDamageSource = projectile.weapon;
    }  
}

if(global.gibLevel > 0 and blood > 0)
{
    repeat(blood)
    {
        blood = instance_create(x,y,Blood);
        blood.direction = direction-180;
    }
}
dealFlicker(shotCharacter.id);
