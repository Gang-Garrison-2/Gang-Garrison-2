var i;

for(i=0; i<256; i+=1) {
    requiredBytes[i] = 0;
}

requiredBytes[PLAYER_HAT] = 1;
requiredBytes[PLAYER_LEAVE] = 0;
requiredBytes[PLAYER_CHANGECLASS] = 1;
requiredBytes[PLAYER_CHANGETEAM] = 1;
requiredBytes[CHAT_BUBBLE] = 1;
requiredBytes[BUILD_SENTRY] = 0;
