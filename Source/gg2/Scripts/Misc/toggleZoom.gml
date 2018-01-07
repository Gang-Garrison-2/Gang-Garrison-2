with(argument0) {
    zoomed = !zoomed;
    if(zoomed) {
        runPower = 0.6;
        jumpStrength = 6+(0.6/2);
        with(currentWeapon)
            hitDamage = baseDamage;
    } else {
        runPower = baseRunPower;
        jumpStrength = baseJumpStrength;
        with(currentWeapon)
            hitDamage = unscopedDamage;
    }
}
