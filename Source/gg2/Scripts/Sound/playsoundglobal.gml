//argument0 global sound sample to play
{
    gen = faudio_new_generator(argument0);
    faudio_volume_generator(1.0, gen); //play at full volume
    faudio_fire_generator(gen);
    faudio_kill_generator(gen); //free generator from memory
}
