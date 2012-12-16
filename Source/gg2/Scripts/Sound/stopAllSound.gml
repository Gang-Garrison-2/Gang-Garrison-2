//Stops all sound, including those played by the audio extension
sound_stop_all();
if audio_is_playing(AudioControl.currentSong)
    audio_stop(AudioControl.currentSong)
