// Add the entry to the chatbox log
ds_list_add(global.chatbox.chatLog, argument0);

// Delete the oldest entry if there are too many
if ds_list_size(global.chatbox.chatLog) > 20
{
    ds_list_delete(global.chatbox.chatLog, 0);
}

global.chatbox.alarm[1] = 30;
