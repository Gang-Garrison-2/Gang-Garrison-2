// cleans up server-sent plugins
// Restart or quit GG2 so that plugins aren't kept in memory

var prompt;

if (global.restartPrompt == 1)
{
    prompt = show_message_ext(
        "Because you used this server's plugins, you will have to restart GG2 to play on another server.",
        "Restart", // 1
        "",
        "Quit"     // 3
    );
    if (prompt == 1)
        restartGG2();
    else 
        game_end()
}
else
    restartGG2();
