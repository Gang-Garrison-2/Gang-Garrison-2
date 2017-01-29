// dealDamage( sourcePlayer, damagedObject, damageDealt )
with(argument1)
{
    if(variable_local_exists("deathmatch_invulnerable"))
    {
        if(argument1.deathmatch_invulnerable != 0)
            return 0;
    }
}

argument1.hp -= argument2;

execute_string( global.dealDamageFunction, argument0, argument1, argument2 );

