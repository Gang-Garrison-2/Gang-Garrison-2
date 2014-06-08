{
    var vol;
    vol = calculateVolume(argument0, argument1);
    if(vol==0) exit;
    faudio_volume_generator(argument2, vol);
    faudio_pan_generator (argument2, calculatePan(argument0));
    faudio_fire_generator(argument2);
    show_debug_message(faudio_get_generator_playing(argument2))
    //show_debug_message(show_debug_message(faudio_get_generator_playing(argument2)))
}
