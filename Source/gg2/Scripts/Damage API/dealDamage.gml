// dealDamage( sourcePlayer, damagedObject, damageDealt )
with(argument1)
{
    // Only characters have deathmatch_invulnerable (always set in Character Create).
    if(object_index == Character or object_is_ancestor(object_index, Character))
    {
        if(argument1.deathmatch_invulnerable != 0)
            return 0;
    }
}

argument1.hp -= argument2;

// PLUGINS(disabled): no runtime GML execution in ENIGMA; revisit
// execute_string( global.dealDamageFunction, argument0, argument1, argument2 );

