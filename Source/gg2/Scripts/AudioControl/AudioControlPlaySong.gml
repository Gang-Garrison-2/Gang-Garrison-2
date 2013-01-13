// sets the currently playing song
// if you specify sound -1, it will stop the current song

// argument0 - sound resource
// argument1 - loop

if(AudioControl.currentSong != -1) audio_stop(AudioControl.currentSong);

AudioControl.currentSong = argument0;
AudioControl.currentSongLoop = argument1;

if(AudioControl.currentSong != -1) {
    AudioControl.currentSongPlayed = true;
    if(AudioControl.currentSongLoop) {
        audio_set_repeat(AudioControl.currentSong, true);
        audio_play(AudioControl.currentSong, true);
    } else {
        audio_play(AudioControl.currentSong, true);
    }
    if (AudioControl.allAudioMuted = true)
        audio_set_volume(AudioControl.currentSong, 0)
}
