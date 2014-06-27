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
nummaps = 20;

maprooms[0] = Truefort
maprooms[1] = TwodFortTwoRemix
maprooms[2] = Conflict
maprooms[3] = Avanti
maprooms[4] = ClassicWell
maprooms[5] = Waterway
maprooms[6] = Orange
maprooms[7] = Dirtbowl
maprooms[8] = Egypt
maprooms[9] = Montane
maprooms[10] = Lumberyard
maprooms[11] = Destroy
maprooms[12] = Valley
maprooms[13] = Corinth
maprooms[14] = Harvest
maprooms[15] = Atalia
maprooms[16] = Sixties
maprooms[17] = DebugRoom
maprooms[18] = CustomMapRoom
maprooms[19] = Oldfort

for(i = 0; i < nummaps; i += 1)
{
    room_set_view(maprooms[i], 0, true,
                  0, 0, global.ingamewidth, global.ingameheight, 
                  0, 0, global.ingamewidth, global.ingameheight,
                  0, 0, 0, 0, noone);
}

