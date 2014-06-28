//argument 0 - x
//argument 1 - y
//argument 2 - sound scalar
//argument 3 - generator sample
{
    var volScale;
    volScale = max(0, min(1, argument2));
    faudio_volume_generator(argument3, volScale * calculateVolume(argument0, argument1));
    faudio_pan_generator(argument3, calculatePan(argument0));
}
