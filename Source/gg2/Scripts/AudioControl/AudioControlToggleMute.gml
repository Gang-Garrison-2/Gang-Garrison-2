// toggles the global mute on or off

if(AudioControl.allAudioMuted) {
    AudioControl.allAudioMuted = false;
    faudio_global_volume(1);
} else {
    AudioControl.allAudioMuted = true;
    faudio_global_volume(0);
}
