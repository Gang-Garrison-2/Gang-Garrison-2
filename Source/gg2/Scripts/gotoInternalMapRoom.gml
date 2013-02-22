// switches to the internal map named in argument0
// if argument1 is true, then returns true if map exists, but does not go to room
// returns 0 in success, -1 if the name isn't recognized

{
    switch(argument0) {
        case "ctf_truefort":
            if (argument1) return true;
            room_goto_fix(Truefort);
            break;
        case "ctf_conflict":
            if (argument1) return true;
            room_goto_fix(Conflict);
            break;
        case "ctf_classicwell":
            if (argument1) return true;
            room_goto_fix(ClassicWell);
            break;
        case "ctf_waterway":
            if (argument1) return true;
            room_goto_fix(Waterway);
            break;
        case "ctf_orange":
            if (argument1) return true;
            room_goto_fix(Orange);
            break;
        case "cp_dirtbowl":
            if (argument1) return true;
            room_goto_fix(Dirtbowl);
            break;
        case "cp_egypt":
            if (argument1) return true;
            room_goto_fix(Egypt);
            break;
        case "arena_montane":
            if (argument1) return true;
            room_goto_fix(Montane);
            break;
        case "arena_lumberyard":
            if (argument1) return true;
            room_goto_fix(Lumberyard);
            break;
        case "gen_destroy":
            if (argument1) return true;
            room_goto_fix(Destroy);
            break;
        case "koth_harvest":
            if (argument1) return true;
            room_goto_fix(Harvest);
            break;
        case "koth_valley":
            if (argument1) return true;
            room_goto_fix(Valley);
            break;
        case "koth_corinth":
            if (argument1) return true;
            room_goto_fix(Corinth);
            break;
        case "dkoth_atalia":
            if (argument1) return true;
            room_goto_fix(Atalia);
            break;
        case "dkoth_sixties":
        case "dkoth_60s":
            if (argument1) return true;
            room_goto_fix(Sixties);
            break;
        case "ctf_2dfort[0]":
        case "ctf_2dfort1":
        case "ctf_oldfort":
            if (argument1) return true;
            room_goto_fix(Oldfort);
            break;
        case "ctf_2dfort":
        case "ctf_2dfort2":
        case "ctf_2dfortremix":
            if (argument1) return true;
            room_goto_fix(TwodFortTwoRemix);
            break;
        default:
            return -1;
            exit;
    }
    return 0;
}
