/**
 * Gets an inverted/mirrored entity. (This is quite hacky but it works fine)
 * Argument0: The entity name you want to invert.
 * Returns the inverted entity name.
*/

var tmpTool;
tmpTool = argument0;
if (string_count("red", tmpTool) > 0 || string_count("Red", tmpTool) > 0) tmpTool = string_replace_all(string_replace_all(tmpTool, "red", "blue"), "Red", "Blue");
else tmpTool = string_replace_all(string_replace_all(tmpTool, "blue", "red"), "Blue", "Red");

if (string_count("left", tmpTool) > 0 || string_count("Left", tmpTool) > 0) tmpTool = string_replace_all(string_replace_all(tmpTool, "left", "right"), "Left", "Right");
else tmpTool = string_replace_all(string_replace_all(tmpTool, "right", "left"), "Right", "Left");

return tmpTool;
