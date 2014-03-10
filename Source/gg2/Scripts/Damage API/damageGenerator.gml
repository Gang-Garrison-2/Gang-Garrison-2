// damageGenerator( sourcePlayer, damagedGenerator, damageDealt )

argument1.alarm[0] = argument1.regenerationBuffer / global.delta_factor;
argument1.isShieldRegenerating = false;

if (argument2 > argument1.shieldHp) //allow overkill to be applied directly to the target
{
    dealDamage( argument0, argument1, (argument2 - argument1.shieldHp) + (argument1.shieldHp * argument1.shieldResistance) );
    argument1.shieldHp = 0;
}
else
{
    dealDamage( argument0, argument1, argument2 * argument1.shieldResistance );
    argument1.shieldHp -= argument2;
}

