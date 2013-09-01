// switches to the internal map named in argument0
// returns 0 in success, -1 if the name isn't recognized

switch(argument0)
{
case "ctf_truefort":
case "ctf_conflict":
case "ctf_classicwell":
case "ctf_waterway":
case "ctf_orange":
case "cp_dirtbowl":
case "cp_egypt":
case "arena_montane":
case "arena_lumberyard":
case "gen_destroy":
case "koth_harvest":
case "koth_valley":
case "koth_corinth":
case "dkoth_atalia":
case "dkoth_sixties":
case "dkoth_60s":
case "ctf_2dfort[0]":
case "ctf_2dfort1":
case "ctf_oldfort":
case "ctf_2dfort":
case "ctf_2dfort2":
case "ctf_2dfortremix":
    return true;
    exit;
default:
    return false;
    exit;
}
return 0;
