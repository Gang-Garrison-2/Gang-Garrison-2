// Sets the weapon for 
// argument0: the weapon

if(hasRewardWeapon(argument0.ownerPlayer))
    with(argument0)
        if(variable_local_exists("goldSprite"))
            sprite_index = goldSprite;
