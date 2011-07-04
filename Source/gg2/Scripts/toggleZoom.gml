if instance_exists(argument0){
    argument0.zoomed = !argument0.zoomed;
    if argument0.zoomed {
        argument0.runPower = 0.6;
        argument0.jumpStrength = 6;
    } else {
        argument0.runPower = 0.9;
        argument0.jumpStrength = 8;
    }
}
