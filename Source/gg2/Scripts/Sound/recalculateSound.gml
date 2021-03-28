{
    var vol;
    vol = calculateVolume(argument0, argument1);
    if(vol==0) exit;
    faudio_volume_generator(argument2, vol);
    pan = calculatePan(argument0);
    faudio_pan_generator (argument2, pan);
}
