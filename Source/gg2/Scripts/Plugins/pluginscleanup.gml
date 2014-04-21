// cleans up server-sent plugins
// Restart or quit GG2 so that plugins aren't kept in memory
if (argument1 != 1)
{
    argument1 = -1;
}
var prompt, msg;

msg = "Because you used this server's plugins, you will have to restart GG2 to play on another server."

if (global.restartPrompt == 1)
{
    if (argument1 == 1)
    {
        promptRestartOrQuit(msg);
    }
    else
    {
        promptRestartQuitOrCancel(msg)
    }
}
else
{
    restartGG2();
}
