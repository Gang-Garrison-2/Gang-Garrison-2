//argument 0 - x
//argument 1 - y
//argument 2 - volume scalar, must be between 0 and 1
//argument 3 - generator
{
    //generator bugs out if it is already playing the same sound effect
    if (faudio_get_generator_playing(argument3) == 1){
        faudio_stop_generator(argument3);
    }
    
    var vol, volScale;
    volScale = max(0, min(1, argument2));
    vol = volScale*calculateVolume(argument0, argument1);
    if(vol==0) exit;
    faudio_volume_generator(argument3, vol);
    pan = calculatePan(argument0);
    faudio_pan_generator (argument2, pan);
    faudio_fire_generator(argument2);
}
