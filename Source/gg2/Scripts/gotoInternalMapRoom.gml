// switches to the internal map named in argument0
// returns 0 in success, -1 if the name isn't recognized

{
    switch(argument0) {
        case "ctf_truefort":
            room_goto_fix(Truefort);
            break;
        case "ctf_2dfort":
            room_goto_fix(TwodFortTwo);
            break;
        case "ctf_conflict":
            room_goto_fix(Conflict);
            break;
        case "ctf_classicwell":
            room_goto_fix(ClassicWell);
            break;
        case "ctf_waterway":
            room_goto_fix(Waterway);
            break;
        case "ctf_orange":
            room_goto_fix(Orange);
            break;
        case "cp_dirtbowl":
            room_goto_fix(Dirtbowl);
            break;
        case "cp_egypt":
            room_goto_fix(Egypt);
            break;
        case "arena_montane":
            room_goto_fix(Montane);
            break;
        case "arena_lumberyard":
            room_goto_fix(Lumberyard);
            break;
        case "gen_destroy":
            room_goto_fix(Destroy);
            break;
        case "koth_harvest":
            room_goto_fix(Harvest);
            break;
        case "koth_valley":
            room_goto_fix(Valley);
            break;
        case "koth_corinth":
            room_goto_fix(Corinth);
            break;
        case "dkoth_atalia":
            room_goto_fix(Atalia);
            break;
        case "dkoth_sixties":
        case "dkoth_60s":
            room_goto_fix(Sixties);
            break;
        case "ctf_2dfort[0]":
        case "ctf_2dfort1":
        case "ctf_oldfort":
            room_goto_fix(Oldfort);
            break;
        case "ctf_2dfort2":
        case "ctf_2dfortremix":
            room_goto_fix(TwodFortTwoRemix);
            break;
        default:
            return -1;
            exit;
    }
    return 0;
}
