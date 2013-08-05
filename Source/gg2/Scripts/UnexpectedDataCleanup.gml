//99% carbon copy of pluginscleanup but who cares
var restart, prompt;

restart = false;
if (global.unexpectedDataPrompt)
{
    prompt = show_message_ext(
        "The Server sent unexpected data",
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