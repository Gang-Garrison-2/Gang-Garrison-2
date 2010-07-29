if global.special == MOUSE_LEFT && !mouse_check_button_pressed(mb_left) exit;
else if global.special == MOUSE_RIGHT && !mouse_check_button_pressed(mb_right) exit;

if global.myself.humiliated == 0 && global.myself.class == CLASS_ENGINEER 
{
    if !instance_exists(BuildMenu) instance_create(0,0,BuildMenu);
    else if instance_exists(BuildMenu) with (BuildMenu) done=true;
}

else if global.myself.humiliated == 0 && global.myself.object.taunting==false && global.myself.object.omnomnomnom==false && global.myself.class==CLASS_HEAVY {
    clearbuffer(global.sendBuffer);
    writebyte(OMNOMNOMNOM,global.sendBuffer);
    sendmessage(global.serverSocket, 0, 0, global.sendBuffer);
}

else if global.myself.class == CLASS_SNIPER {
    if global.myself.object.zoomed == 0 {
       clearbuffer(global.sendBuffer);
       writebyte(SCOPE_IN,global.sendBuffer);
       sendmessage(global.serverSocket, 0, 0, global.sendBuffer);
    } else if global.myself.object.zoomed == 1 {
      clearbuffer(global.sendBuffer);
      writebyte(SCOPE_OUT,global.sendBuffer);
      sendmessage(global.serverSocket, 0, 0, global.sendBuffer);
    }
}
