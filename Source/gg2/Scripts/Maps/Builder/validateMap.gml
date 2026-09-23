/** 
 * Validates the gamemode
 * Argument0: the gamemode that should be validated
 * Returns true if the map is valid
*/

var gmMap, code, error;
gmMap = ds_list_find_value(global.gamemodes, argument0);

// Basic validation
var redCount, blueCount;
redCount = 0;
blueCount = 0;
with(LevelEntity) {
    if (type == "redspawn") redCount += 1;
    else if (type == "bluespawn") blueCount += 1;
}
if (redCount == 0 ||blueCount == 0) {
    show_message("Your setup is not valid.#Every map needs at least red and blue spawnpoints.");
    return false;
} 

if (gmMap != -1) {
    code = ds_map_find_value(gmMap, "code");
    if (code >= 0) {
        error = ds_map_find_value(gmMap, "error");
        if (!is_string(error)) error = "Your setup is not valid.";
        else error = "Your setup is not valid:#" + error;
        
        if (!run_action(code, 0)) {
            if (show_message_ext(error, "Continue", "Cancel", "") != 1) return false;
        }
    }
}

return true;
