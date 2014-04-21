// Prompts to cleans up server-sent plugins

var prompt;

if (global.restartPrompt == 1)
    promptRestartQuitOrCancel("Because you used this server's plugins, you will have to restart GG2 to play on another server.");
else
    restartGG2();
