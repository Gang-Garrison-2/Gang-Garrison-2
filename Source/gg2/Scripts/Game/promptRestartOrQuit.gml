// Ask the user whether he wants to restart the game, or quit.
// This is used in situations where simply continuing to run is not advisable,
// e.g. on unexpected errors (server sent unexpected data) or because plugin
// code needs to be unloaded.
// argument0: message
// argument1: (optional) show cancel button

var promptText, result, button2;
promptText = argument0;
button2 = ""

if (argument1)
    button2 = "Cancel"
    
result = show_message_ext(
    promptText,
    "Restart", // 1
    button2,   // 2
    "Quit"     // 3
);

switch(result)
{
case 1:
    restartGG2();
    break;
case 2:
    exit;
    break;
case 3:
    game_end();
    break;
}
