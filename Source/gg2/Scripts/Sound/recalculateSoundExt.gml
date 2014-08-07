//argument0 = x
//argument1 =  y
//argument2 = sound scalar
//argument3 = generator
{
    var vol, volScale;
    volScale = max(0, min(1, argument2));
    vol = volScale*calculateVolume(argument0, argument1);
    if(vol==0) exit;
    faudio_volume_generator(argument3, vol);
    pan = calculatePan(argument0);
    faudio_pan_generator (argument3, pan);
}
