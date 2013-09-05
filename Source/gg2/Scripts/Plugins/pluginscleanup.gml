// cleans up server-sent plugins
// Restart or quit GG2 so that plugins aren't kept in memory

var prompt;

if (global.restartPrompt == 1)
    promptRestartOrQuit("Because you used this server's plugins, you will have to restart GG2 to play on another server.");
else
    restartGG2();
