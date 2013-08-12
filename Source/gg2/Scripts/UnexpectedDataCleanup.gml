//99% carbon copy of pluginscleanup but who cares
var prompt;

if (global.unexpectedDataReset == 1)
{
    prompt = show_message_ext(
        "The Server sent unexpected data",
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
