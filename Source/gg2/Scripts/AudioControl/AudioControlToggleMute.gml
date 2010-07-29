// toggles the global mute on or off

// NOTE: the music stuff has been commented out because it's no longer needed.
// Since the switch to wav music, changing the global volume now also
// affects music.

{
    if(AudioControl.allAudioMuted) {
        AudioControl.allAudioMuted = false;
        sound_global_volume(100);
        //if(AudioControl.currentSong != -1) {
        //    if(AudioControl.currentSongLoop)
        //        sound_loop(AudioControl.currentSong);
        //    else {
        //        if(!AudioControl.currentSongPlayed)
        //            sound_play(AudioControl.currentSong);
        //    }
        //    AudioControl.currentSongPlayed = true;
        //}
    } else {
        AudioControl.allAudioMuted = true;
        sound_global_volume(0);
        //if(AudioControl.currentSong != -1) {
        //    sound_stop(AudioControl.currentSong);
        //}
    }
}