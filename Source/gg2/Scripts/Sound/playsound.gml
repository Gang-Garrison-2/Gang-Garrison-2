{
    //generator bugs out if it is already playing the same sound effect
    if (faudio_get_generator_playing(argument2) == 1){
        faudio_stop_generator(argument2);
    }
    
    var vol;
    vol = calculateVolume(argument0, argument1);
    if(vol==0) exit;
    faudio_volume_generator(argument2, vol);
    pan = calculatePan(argument0);
    faudio_pan_generator (argument2, pan);
    faudio_fire_generator(argument2);
}
