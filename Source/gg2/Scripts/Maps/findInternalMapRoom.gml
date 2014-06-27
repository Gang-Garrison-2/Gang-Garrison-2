// returns the room of an internal map by name, or else (if it's not a valid internal map), false

switch(argument0)
{
case "ctf_truefort":
    return Truefort;
case "ctf_2dfort":
case "ctf_2dfort2":
case "ctf_2dfortremix":
    return TwodFortTwoRemix;
case "ctf_conflict":
    return Conflict;
case "ctf_classicwell":
    return ClassicWell;
case "ctf_waterway":
    return Waterway;
case "ctf_orange":
    return Orange;
case "ctf_avanti":
    return Avanti;
case "cp_dirtbowl":
    return Dirtbowl;
case "cp_egypt":
    return Egypt;
case "arena_montane":
    return Montane;
case "arena_lumberyard":
    return Lumberyard;
case "gen_destroy":
    return Destroy;
case "koth_harvest":
    return Harvest;
case "koth_valley":
    return Valley;
case "koth_corinth":
    return Corinth;
case "dkoth_atalia":
    return Atalia;
case "dkoth_sixties":
case "dkoth_60s":
    return Sixties;
case "tdm_mantic":
    return Mantic;
case "ctf_2dfort[0]":
case "ctf_2dfort1":
case "ctf_oldfort":
    return Oldfort;
case "gg_debug":
    return DebugRoom;
default:
    return false;
}
