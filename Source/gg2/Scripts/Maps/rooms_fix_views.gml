// Fix room view resolutions
switch(global.resolutionkind)
{
case 0: // 5:4
    global.ingamewidth = 780;
    global.ingameheight = 624;
    break;
case 1: // 4:3
    global.ingamewidth = 800;
    global.ingameheight = 600;
    break;
case 2: // 16:10
    global.ingamewidth = 848;
    global.ingameheight = 530;
    break;
case 3: // 16:9
    global.ingamewidth = 864;
    global.ingameheight = 486;
    break;
case 4: // 2:1
    global.ingamewidth = 888;
    global.ingameheight = 444;
    break;
}

var maprooms, nummaps;
nummaps = 2;

maprooms[0] = CustomMapRoom
maprooms[1] = BuilderRoom

for(i = 0; i < nummaps; i += 1)
{
    room_set_view(maprooms[i], 0, true,
                  0, 0, global.ingamewidth, global.ingameheight, 
                  0, 0, global.ingamewidth, global.ingameheight,
                  0, 0, 0, 0, noone);
}

