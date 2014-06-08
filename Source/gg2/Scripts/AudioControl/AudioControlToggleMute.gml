// toggles the global mute on or off

if(AudioControl.allAudioMuted) {
    AudioControl.allAudioMuted = false;
    createGenerators();
} else {
    AudioControl.allAudioMuted = true;
    faudio_kill_all_generators();
}
