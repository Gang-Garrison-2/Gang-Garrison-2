// cleans up server-sent plugins
// Restart or quit GG2 so that plugins aren't kept in memory

var restart;

restart = !global.restartPrompt;

if (!restart)
{
    restart = (show_message_ext("Because you used this server's plugins, you will have to restart GG2 to play on another server.","Restart","","Quit") == 1);
}            

if (restart)
{
    execute_program(parameter_string(0), "-restart", false);
}
game_end();
