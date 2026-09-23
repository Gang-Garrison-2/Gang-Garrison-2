// returns the filename of an internal map by name, or else (if it's not a valid internal map), ""

// TODO(enigma): if chain instead of switch; ENIGMA can't switch on strings. Restore switch when fixed
var name;
name = argument0;

if (name == "ctf_truefort")
    return "ctf_truefort.png";
if (name == "ctf_2dfort" or name == "ctf_2dfort2" or name == "ctf_2dfortremix")
    return "ctf_2dfort.png";
if (name == "ctf_conflict")
    return "ctf_conflict.png";
if (name == "ctf_classicwell")
    return "ctf_classicwell.png";
if (name == "ctf_waterway")
    return "ctf_waterway.png";
if (name == "ctf_orange")
    return "ctf_orange.png";
if (name == "ctf_avanti")
    return "ctf_avanti.png";
if (name == "cp_dirtbowl")
    return "cp_dirtbowl.png";
if (name == "cp_egypt")
    return "cp_egypt.png";
if (name == "arena_montane")
    return "arena_montane.png";
if (name == "arena_lumberyard")
    return "arena_lumberyard.png";
if (name == "gen_destroy")
    return "gen_destroy.png";
if (name == "koth_harvest")
    return "koth_harvest.png";
if (name == "koth_valley")
    return "koth_valley.png";
if (name == "koth_corinth")
    return "koth_corinth.png";
if (name == "dkoth_atalia")
    return "dkoth_atalia.png";
if (name == "dkoth_sixties" or name == "dkoth_60s")
    return "dkoth_sixties.png";
if (name == "tdm_mantic")
    return "tdm_mantic.png";
if (name == "ctf_2dfort[0]" or name == "ctf_2dfort1" or name == "ctf_oldfort")
    return "ctf_oldfort.png";
if (name == "gg_debug")
    return "gg_debug.png";
if (name == "koth_gallery")
    return "koth_gallery.png";
if (name == "ctf_eiger")
    return "ctf_eiger.png";
return "";
