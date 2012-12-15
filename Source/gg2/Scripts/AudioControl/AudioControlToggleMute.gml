// toggles the global mute on or off

if(AudioControl.allAudioMuted) {
    AudioControl.allAudioMuted = false;
    sound_global_volume(100);
    if(AudioControl.currentSong != -1) 
        audio_set_volume(AudioControl.currentSong, 0.5);
} else {
    AudioControl.allAudioMuted = true;
    sound_global_volume(0)
    if(AudioControl.currentSong != -1) 
        audio_set_volume(AudioControl.currentSong, 0.0);
}
