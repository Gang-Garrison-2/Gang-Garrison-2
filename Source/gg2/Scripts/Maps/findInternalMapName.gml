// returns the filename of an internal map by name, or else (if it's not a valid internal map), ""

switch(argument0)
{
case "ctf_truefort":
    return "ctf_truefort.png";
case "ctf_2dfort":
case "ctf_2dfort2":
case "ctf_2dfortremix":
    return "ctf_2dfort.png";
case "ctf_conflict":
    return "ctf_conflict.png";
case "ctf_classicwell":
    return "ctf_classicwell.png";
case "ctf_waterway":
    return "ctf_waterway.png";
case "ctf_orange":
    return "ctf_orange.png";
case "ctf_avanti":
    return "ctf_avanti.png";
case "cp_dirtbowl":
    return "cp_dirtbowl.png";
case "cp_egypt":
    return "cp_egypt.png";
case "arena_montane":
    return "arena_montane.png";
case "arena_lumberyard":
    return "arena_lumberyard.png";
case "gen_destroy":
    return "gen_destroy.png";
case "koth_harvest":
    return "koth_harvest.png";
case "koth_valley":
    return "koth_valley.png";
case "koth_corinth":
    return "koth_corinth.png";
case "dkoth_atalia":
    return "dkoth_atalia.png";
case "dkoth_sixties":
case "dkoth_60s":
    return "dkoth_sixties.png";
case "tdm_mantic":
    return "tdm_mantic.png";
case "ctf_2dfort[0]":
case "ctf_2dfort1":
case "ctf_oldfort":
    return "ctf_oldfort.png";
case "gg_debug":
    return "gg_debug.png";
case "koth_gallery":
    return "koth_gallery.png";
case "ctf_eiger":
    return "ctf_eiger.png";
default:
    return "";
}
