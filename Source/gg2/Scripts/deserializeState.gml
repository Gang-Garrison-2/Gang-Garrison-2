// Read state data from the global.serverSocket and deserialize it
// argument0: Type of the state update

global.updateType = argument0;

receiveCompleteMessage(global.serverSocket,1,0);
if(readbyte(0) != ds_list_size(global.players)) {
	show_message("Wrong number of players while deserializing state");
}

for(i=0; i<ds_list_size(global.players); i+=1) {
	player = ds_list_find_value(global.players, i);
	with(player) {
		event_user(13);
	}
}

if(argument0 == FULL_UPDATE) {
	deserialize(IntelligenceRed);
	deserialize(IntelligenceBlue);

	receiveCompleteMessage(global.serverSocket,4,0);
	global.redCaps = readushort(0);
	global.blueCaps = readushort(0);
}