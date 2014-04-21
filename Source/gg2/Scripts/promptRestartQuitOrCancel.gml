// Ask the user whether he wants to restart the game, or quit. with a cancel button

var promptText, result;
promptText = argument0;


result = show_message_ext(
    promptText,
    "Restart", // 1
    "Cancel",  // 2
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

