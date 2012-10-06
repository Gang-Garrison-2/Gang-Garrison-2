// Read state data from the global.serverSocket and deserialize it
// argument0: Type of the state update

global.updateType = argument0;

receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
if(read_ubyte(global.tempBuffer) != ds_list_size(global.players)) {
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

receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
      global.caplimit = read_ubyte(global.tempBuffer);
global.redCaps = read_ubyte(global.tempBuffer);
global.blueCaps = read_ubyte(global.tempBuffer);
      global.Server_RespawntimeSec = read_ubyte(global.tempBuffer);
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
        else if instance_exists(KothHUD) {
            with KothHUD event_user(13);
        }
        else if instance_exists(DKothHUD) {
            with DKothHUD event_user(13);
        }
}

if(argument0 == CAPS_UPDATE) {
    receiveCompleteMessage(global.serverSocket,3,global.tempBuffer);          
    global.redCaps = read_ubyte(global.tempBuffer);
    global.blueCaps = read_ubyte(global.tempBuffer);
    global.Server_RespawntimeSec = read_ubyte(global.tempBuffer);

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
    else if instance_exists(KothHUD) {
            with KothHUD event_user(13);
    }
    else if instance_exists(DKothHUD) {
            with DKothHUD event_user(13);
    }
}
