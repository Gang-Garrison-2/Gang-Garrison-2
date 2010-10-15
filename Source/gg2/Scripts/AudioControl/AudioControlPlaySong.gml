// sets the currently playing song
// if you specify sound -1, it will stop the current song

// argument0 - sound resource
// argument1 - loop

if(AudioControl.currentSong != -1) sound_stop(AudioControl.currentSong);

AudioControl.currentSong = argument0;
AudioControl.currentSongLoop = argument1;

if(AudioControl.currentSong != -1) {
    AudioControl.currentSongPlayed = true;
    if(AudioControl.currentSongLoop) {
        sound_loop(AudioControl.currentSong);
    } else {
        sound_play(AudioControl.currentSong);
    }
}
