with(argument0) {
    zoomed = !zoomed;
    if(zoomed) {
        runPower = 0.6;
        jumpStrength = 6;
        with(currentWeapon)
            hitDamage = baseDamage;
    } else {
        runPower = 0.9;
        jumpStrength = 8;
        with(currentWeapon)
            hitDamage = unscopedDamage;
    }
}
