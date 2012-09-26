if(global.myself.class == CLASS_ENGINEER)
{
    if(global.myself.sentry)
    {
        write_ubyte(global.serverSocket, DESTROY_SENTRY);
        socket_send(global.serverSocket);
    }
    else if(global.myself.object.nutsNBolts < 100)
    {
        with(NoticeO)
            instance_destroy();
        instance_create(0,0,NoticeO);
        NoticeO.notice = NOTICE_NUTSNBOLTS;
    }
    else if(collision_circle(global.myself.object.x,global.myself.object.y,50,Sentry,false,true)>=0)
    {
        with(NoticeO)
            instance_destroy();
        instance_create(0,0,NoticeO);
        NoticeO.notice = NOTICE_TOOCLOSE;
    }
    else if(collision_point(global.myself.object.x,global.myself.object.y,SpawnRoom,0,0) < 0)
    {
        write_ubyte(global.serverSocket, BUILD_SENTRY);
        socket_send(global.serverSocket);
    }
} else if global.myself.object.taunting==false && global.myself.object.omnomnomnom==false && global.myself.class==CLASS_HEAVY {
    write_ubyte(global.serverSocket, OMNOMNOMNOM);
} else if global.myself.class == CLASS_SNIPER {
    write_ubyte(global.serverSocket, TOGGLE_ZOOM);
}
