// cleans up server-sent plugins
// Restart or quit GG2 so that plugins aren't kept in memory

var restart, prompt;

restart = false;
if (global.restartPrompt)
{
    prompt = show_message_ext(
        "Because you used this server's plugins, you will have to restart GG2 to play on another server.",
        "Restart", // 1
        "",
        "Quit"     // 3
    );
    if (prompt == 1)
    {
        restart = true;
    }
}
else
{
    restart = true;
}    

if (restart)
{
    execute_program(parameter_string(0), "-restart", false);
}
game_end();
