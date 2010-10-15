// toggles the global mute on or off

if(AudioControl.allAudioMuted) {
    AudioControl.allAudioMuted = false;
    sound_global_volume(100);
} else {
    AudioControl.allAudioMuted = true;
    sound_global_volume(0);
}
