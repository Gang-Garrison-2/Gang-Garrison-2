    var input;
    input = argument0
    
    while string_length(input) > 10// String is too long, break it in pieces and print each on a separate line
    {
        var position, longMessage, oldPosition, prefix;
       
        position = 0
        oldPosition = 0
        longMessage = string_copy(input, 0, 83)
     
        if string_count(" ", longMessage) != 0// Break the line at spaces if possible
        {
            while string_count(" ", longMessage) > 0
            {
                position = string_pos(" ", longMessage)
                oldPosition += position
                longMessage = string_copy(longMessage, position+1, string_length(longMessage))
            }
           
            ds_list_add(global.chatbox.chatLog, string_copy(input, 0, oldPosition));
            show_message(input)
            prefix = string_copy(input, 0, 4)
            input = string_copy(input, oldPosition+1, string_length(input));
     
            if string_copy(prefix, 0, 3) == "/:/"// A color code was there, prepend this to the next line too
            {
                input = prefix+input
            }
     
        }
        else// Just break it normally if there are no spaces
        {
            ds_list_add(global.chatbox.chatLog, string_copy(input, 0, 83));
            show_message(input)
            prefix = string_copy(input, 0, 4)
            input = string_copy(input, 84, string_length(input));
     
            if string_copy(prefix, 0, 3) == "/:/"// A color code was there, prepend this to the next line too
            {
                input = prefix+input
            }
        }
    }
     

// Add the entry to the chatbox log
show_message(input)
ds_list_add(global.chatbox.chatLog, input);

// Delete the oldest entry if there are too many
if ds_list_size(global.chatbox.chatLog) > 20
{
    ds_list_delete(global.chatbox.chatLog, 0);
}

global.chatbox.alarm[1] = 30;
