var noOfPlayers;
noOfPlayers = ds_list_size(global.players);
if(global.dedicatedMode)
    noOfPlayers -= 1;
return noOfPlayers;
