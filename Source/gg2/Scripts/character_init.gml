// Initialize character and team maps along with default classes and teams

var redCharacterMap, blueCharacterMap;

redCharacterMap = ds_map_create();
blueCharacterMap = ds_map_create();
global.teamMap = ds_map_create();

ds_map_add(global.teamMap, TEAM_RED, redCharacterMap);
ds_map_add(global.teamMap, TEAM_BLUE, blueCharacterMap);

ds_map_add(redCharacterMap, CLASS_SCOUT, ScoutRed);
ds_map_add(redCharacterMap, CLASS_PYRO, PyroRed);
ds_map_add(redCharacterMap, CLASS_SOLDIER, SoldierRed);
ds_map_add(redCharacterMap, CLASS_DEMOMAN, DemomanRed);
ds_map_add(redCharacterMap, CLASS_HEAVY, HeavyRed);
ds_map_add(redCharacterMap, CLASS_ENGINEER, EngineerRed);
ds_map_add(redCharacterMap, CLASS_MEDIC, MedicRed);
ds_map_add(redCharacterMap, CLASS_SPY, SpyRed);
ds_map_add(redCharacterMap, CLASS_SNIPER, SniperRed);
ds_map_add(redCharacterMap, CLASS_QUOTE, QuoteRed);

ds_map_add(blueCharacterMap, CLASS_SCOUT, ScoutBlue);
ds_map_add(blueCharacterMap, CLASS_PYRO, PyroBlue);
ds_map_add(blueCharacterMap, CLASS_SOLDIER, SoldierBlue);
ds_map_add(blueCharacterMap, CLASS_DEMOMAN, DemomanBlue);
ds_map_add(blueCharacterMap, CLASS_HEAVY, HeavyBlue);
ds_map_add(blueCharacterMap, CLASS_ENGINEER, EngineerBlue);
ds_map_add(blueCharacterMap, CLASS_MEDIC, MedicBlue);
ds_map_add(blueCharacterMap, CLASS_SPY, SpyBlue);
ds_map_add(blueCharacterMap, CLASS_SNIPER, SniperBlue);
ds_map_add(blueCharacterMap, CLASS_QUOTE, QuoteBlue);
