// Ask the user whether he wants to restart the game, or quit.
// This is used in situations where simply continuing to run is not advisable,
// e.g. on unexpected errors (server sent unexpected data) or because plugin
// code needs to be unloaded.

var promptText, result;
promptText = argument0;

result = show_message_ext(
    promptText,
    "Restart", // 1
    "",
    "Quit"     // 3
);

if (result == 1)
    restartGG2();
else 
    game_end();
