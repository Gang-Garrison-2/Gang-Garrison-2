//argument 0 - path to sound
sampleID = faudio_new_sample(working_directory + argument0);
if (sampleID == -1){
    message_size = -1;
    show_message("Error Initializing sound file at#" + argument0 + "#Error code:" + faudio_get_error());
    return -1;
}else{
    return sampleID;
}

