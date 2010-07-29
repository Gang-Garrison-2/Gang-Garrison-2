// Read state data from the global.serverSocket and deserialize it
// argument0: Type of the state update

global.updateType = argument0;

receiveCompleteMessage(global.serverSocket,1,0);
if(readbyte(0) != ds_list_size(global.players)) {
show_message("Wrong number of players while deserializing state");
}

if argument0 != CAPS_UPDATE {

    for(i=0; i<ds_list_size(global.players); i+=1) {
   player = ds_list_find_value(global.players, i);
   with(player) {
event_user(13);
   }
    }
}

if(argument0 == FULL_UPDATE) {
deserialize(IntelligenceRed);
deserialize(IntelligenceBlue);

receiveCompleteMessage(global.serverSocket,4,0);
      global.caplimit = readbyte(0);
global.redCaps = readbyte(0);
global.blueCaps = readbyte(0);
      global.Server_RespawntimeSec = readbyte(0);
      global.Server_Respawntime = global.Server_RespawntimeSec * 30;
         
        if instance_exists(ControlPointHUD){
            with ControlPointHUD event_user(13);
        }
        else if instance_exists(ScorePanel){
            with ScorePanel event_user(13);
        }
        else if instance_exists(GeneratorHUD) {
            with GeneratorHUD event_user(13);
        }
        else if instance_exists(ArenaHUD) {
            with ArenaHUD event_user(13);
        }
}

if(argument0 == CAPS_UPDATE) {
    receiveCompleteMessage(global.serverSocket,3,0);          
    global.redCaps = readbyte(0);
    global.blueCaps = readbyte(0);
    global.Server_RespawntimeSec = readbyte(0);

    if instance_exists(ControlPointHUD){
        with ControlPointHUD event_user(13);
    }
    else if instance_exists(ScorePanel){
        with ScorePanel event_user(13);
    }
    else if instance_exists(GeneratorHUD) {
            with GeneratorHUD event_user(13);
    }
    else if instance_exists(ArenaHUD) {
            with ArenaHUD event_user(13);
    }
}
