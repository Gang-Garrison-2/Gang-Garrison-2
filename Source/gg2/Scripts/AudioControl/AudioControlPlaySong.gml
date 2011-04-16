// sets the currently playing song
// if you specify sound -1, it will stop the current song

if(AudioControl.currentSong != -1) sound_stop(AudioControl.currentSong);

AudioControl.currentSong = argument0;
if(argument_count > 1)
    AudioControl.currentSongLoop = argument[1];
else
    AudioControl.currentSongLoop = false;

if(AudioControl.currentSong != -1) {
    AudioControl.currentSongPlayed = true;
    if(AudioControl.currentSongLoop) {
        sound_loop(AudioControl.currentSong);
    } else {
        sound_play(AudioControl.currentSong);
    }
}
