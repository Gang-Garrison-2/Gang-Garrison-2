// Returns the unique identifying index for a game asset from its name (aka the actual resource)
// You should always make sure that an asset with that name exists, otherwise it will crash.
// argument0: The name of the game asset to get the index of (a string)

// Check for possible malformed string or code injection
// Only allow _ as special character
var checkstr;
checkstr = string_replace_all(argument0, "_", "");
if (checkstr != string_lettersdigits(argument0)) {
    show_error("Invalid variable name [" + argument0 + "] for asset_get_index", false);
    exit;
}

return execute_string("return " + argument0);

