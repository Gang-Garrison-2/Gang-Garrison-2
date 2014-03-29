// switches to the internal map named in argument0
// returns 0 in success, -1 if the name isn't recognized

{
    switch(argument0) {
        case "2dfort":
            room_goto_fix(TwodFort);
            break;
	  case "2dfort_2":
	      room_goto_fix(TwodFortTwo);
            break;
        case "helltrikky_1":
            room_goto_fix(HELLTRIKKY1);
            break;
        case "classicwell":
            room_goto_fix(ClassicWell);
            break;
        case "Orange":
            room_goto_fix(Orange);
            break;
        case "Avanti":
            room_goto_fix(Avanti);
            break;
	  case "Castle":
            room_goto_fix(Castle);
            break;
        case "Containment":
            room_goto_fix(Containment);
            break;
        case "Heenok":
            room_goto_fix(Heenok);
            break;
        default:
            return -1;
            exit;
    }
    return 0;
}