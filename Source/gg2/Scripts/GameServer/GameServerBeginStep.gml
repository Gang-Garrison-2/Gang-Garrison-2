if(serverbalance != 0)
    balancecounter+=1;

// Register with Lobby Server every 30 seconds
if(global.useLobbyServer and (frame mod 900)==0)
    sendLobbyRegistration();
frame += 1;

buffer_clear(global.sendBuffer);

global.runningMapDownloads = 0;
global.mapBytesRemainingInStep = global.mapdownloadLimitBps/room_speed;
with(JoiningPlayer)
    if(state==STATE_CLIENT_DOWNLOADING)
        global.runningMapDownloads += 1;

acceptJoiningPlayer();        
with(JoiningPlayer)
    serviceJoiningPlayer();

// Service all players
var i;
for(i=0; i<ds_list_size(global.players); i+=1)
{
    var player;
    player = ds_list_find_value(global.players, i);
    
    if(socket_has_error(player.socket))
    {
        removePlayer(player);
        ServerPlayerLeave(i);
        i-=1;
    }
    else
        processClientCommands(player, i);
}

if(syncTimer == 1 || ((frame mod 3600)==0) || global.setupTimer == 180)
{
    serializeState(CAPS_UPDATE, global.sendBuffer);
    syncTimer = 0;
}

if((frame mod 7) == 0)
    serializeState(QUICK_UPDATE, global.sendBuffer);
else
    serializeState(INPUTSTATE, global.sendBuffer);

if(impendingMapChange > 0)
    impendingMapChange -= 1; // countdown until a map change

if(global.winners != -1 and !global.mapchanging)
{
    if(global.winners == TEAM_RED and global.currentMapArea < global.totalMapAreas)
    {
        global.nextMap = global.currentMap;
        global.currentMapArea += 1;
    }
    else
    { 
        global.currentMapIndex += 1;
        global.currentMapArea = 1;
        if(global.currentMapIndex == ds_list_size(global.map_rotation)) 
            global.currentMapIndex = 0;
        global.nextMap = ds_list_find_value(global.map_rotation, global.currentMapIndex);
    }
    global.mapchanging = true;
    impendingMapChange = 300; // in 300 frames (ten seconds), we'll do a map change
    
    write_ubyte(global.sendBuffer, MAP_END);
    write_ubyte(global.sendBuffer, string_length(global.nextMap));
    write_string(global.sendBuffer, global.nextMap);
    write_ubyte(global.sendBuffer, global.winners);
    write_ubyte(global.sendBuffer, global.currentMapArea);
    
    if(!instance_exists(ScoreTableController))
        instance_create(0,0,ScoreTableController);
    instance_create(0,0,WinBanner);
}

// if map change timer hits 0, do a map change
if(impendingMapChange == 0)
{
    global.mapchanging = false;
    global.currentMap = global.nextMap;
    if(file_exists("Maps/" + global.currentMap + ".png"))
    { // if this is an external map, get the md5 and url for the map
        global.currentMapMD5 = CustomMapGetMapMD5(global.currentMap);
        room_goto_fix(CustomMapRoom);
    }
    else
    { // internal map, so at the very least, MD5 must be blank
        global.currentMapMD5 = "";
        if(gotoInternalMapRoom(global.currentMap) != 0)
        {
            show_message("Error:#Map " + global.currentMap + " is not in maps folder, and it is not a valid internal map.#Exiting.");
            game_end();
        }
    }
    ServerChangeMap(global.currentMap, global.currentMapMD5, global.sendBuffer);
    impendingMapChange = -1;
    
    with(Player)
    {
        if(global.currentMapArea == 1)
        {
            stats[KILLS] = 0;
            stats[DEATHS] = 0;
            stats[CAPS] = 0;
            stats[ASSISTS] = 0;
            stats[DESTRUCTION] = 0;
            stats[STABS] = 0;
            stats[HEALING] = 0;
            stats[DEFENSES] = 0;
            stats[INVULNS] = 0;
            stats[BONUS] = 0;
            stats[DOMINATIONS] = 0;
            stats[REVENGE] = 0;
            stats[POINTS] = 0;
            roundStats[KILLS] = 0;
            roundStats[DEATHS] = 0;
            roundStats[CAPS] = 0;
            roundStats[ASSISTS] = 0;
            roundStats[DESTRUCTION] = 0;
            roundStats[STABS] = 0;
            roundStats[HEALING] = 0;
            roundStats[DEFENSES] = 0;
            roundStats[INVULNS] = 0;
            roundStats[BONUS] = 0;
            roundStats[DOMINATIONS] = 0;
            roundStats[REVENGE] = 0;
            roundStats[POINTS] = 0;
            team = TEAM_SPECTATOR;
        }
        timesChangedCapLimit = 0;
        alarm[5]=1;
    }
}

var i;
for(i=1; i<ds_list_size(global.players); i+=1)
{
    var player;
    player = ds_list_find_value(global.players, i);
    write_buffer(player.socket, global.eventBuffer);
    write_buffer(player.socket, global.sendBuffer);
    socket_send(player.socket);
}
buffer_clear(global.eventBuffer);
