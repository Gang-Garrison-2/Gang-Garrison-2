if(global.myself.class == CLASS_ENGINEER)
{
    // TODO(enigma): temp var avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
    var myObject;
    myObject = global.myself.object;
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
    // TODO(enigma): myObject avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
    else if(collision_circle(myObject.x,myObject.y,50,Sentry,false,true)>=0)
    {
        with(NoticeO)
            instance_destroy();
        instance_create(0,0,NoticeO);
        NoticeO.notice = NOTICE_TOOCLOSE;
    }
    // TODO(enigma): myObject avoids ENIGMA nested built-in dot bug (a.b.x); inline when fixed
    else if(collision_point(myObject.x,myObject.y,SpawnRoom,0,0) < 0)
    {
        write_ubyte(global.serverSocket, BUILD_SENTRY);
        socket_send(global.serverSocket);
    }
} else if global.myself.object.taunting==false && global.myself.object.omnomnomnom==false && global.myself.class==CLASS_HEAVY {
    write_ubyte(global.serverSocket, OMNOMNOMNOM);
} else if global.myself.class == CLASS_SNIPER {
    write_ubyte(global.serverSocket, TOGGLE_ZOOM);
}
