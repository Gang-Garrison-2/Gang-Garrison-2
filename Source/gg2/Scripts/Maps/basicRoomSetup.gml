room_caption = global.currentMap;
global.startedGame = true;
if(!global.fullscreen)
    window_set_position(previous_window_x+previous_window_w/2-global.ingamewidth/2, previous_window_y);

global.totalMapAreas = 1+instance_number(NextAreaO);

if global.totalMapAreas > 1 {
    global.area[1] = 0;
    
    for(i=2;i<=global.totalMapAreas;i+=1) {
        global.area[i] = instance_find(NextAreaO,i-2).y;
    }

    if (global.currentMapArea == 1)
    {
        with all if y > global.area[2] instance_destroy();
    }
    else if global.currentMapArea < global.totalMapAreas {
        with all if (y > global.area[global.currentMapArea+1] || y < global.area[global.currentMapArea]) && y > 0 instance_destroy();
    }
    else if global.currentMapArea == global.totalMapAreas {
        with all if y < global.area[global.currentMapArea] && y > 0 instance_destroy();
    }
}

with(ParallaxController)
    event_user(0);

offloadSpawnPoints();
with(Player) {
    humiliated = 0;
}

global.setupTimer = 0;
if(instance_exists(IntelligenceBase) or instance_exists(Intelligence))
{
    if (instance_exists(ControlPointSetupGate))
        instance_create(0, 0, InvasionHUD);
    else
        instance_create(0, 0, CTFHUD);
}
else if(instance_exists(Generator))
{
    instance_create(0,0,GeneratorHUD);
}
else if(instance_exists(ArenaControlPoint))
{
    instance_create(0, 0, ArenaHUD);
}
else if(instance_exists(KothControlPoint))
{
    instance_create(0,0,KothHUD);
}
else if(instance_exists(KothRedControlPoint) and instance_exists(KothBlueControlPoint))
{
    with(ControlPoint)
        event_user(0);
    instance_create(0,0,DKothHUD);
}
else if instance_exists(ControlPoint)
{
    with(ControlPoint)
        event_user(0);
    instance_create(0,0,ControlPointHUD);
}
else
{
    instance_create(0, 0, TeamDeathmatchHUD);
}

instance_create(0,0,TeamSelectController);
if (!instance_exists(KillLog))
    instance_create(0,0,KillLog);

// Oh hey, I don't actually need to create a dedicated stop all generators function
faudio_stop_generator(-1);
global.IngameMusic = faudio_new_generator(global.IngameMusicS);
if(global.music == MUSIC_BOTH || global.music == MUSIC_INGAME_ONLY) 
{
    
    if(global.IngameMusic != -1)
    {
        faudio_volume_generator(global.IngameMusic, 0.8);
        AudioControlPlaySong(global.IngameMusic, true);
    }
}
instance_create(map_width()/2,map_height()/2,Spectator);

global.redCaps = 0;
global.blueCaps = 0;
global.winners = -1;

if(instance_exists(GameServer))
{
    if(!GameServer.hostSeenMOTD and !global.dedicatedMode and global.welcomeMessage != "")
    {
        with(NoticeO)
            instance_destroy();
        with(instance_create(0, 0, NoticeO))
        {
            notice = NOTICE_CUSTOM;
            message = global.welcomeMessage;
        }
        GameServer.hostSeenMOTD = true;
    }
}
