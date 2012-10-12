// Takes a string as argument and prints it in the chat, breaking up at lines when necessary
// argument0 = input string
var rawInput, partString, pos, tmpString, colorKey;
rawInput = argument0;
rawInput = string_replace_all(rawInput, chr(10), " ");
rawInput = string_replace_all(rawInput, chr(13), " ");
// While the input string minus the color codes is too long for the chat
while string_length(rawInput) - string_count("/:/", rawInput)*(3+COLOR_RGB_LENGTH) > CHAT_MAX_LINE_LENGTH
{
    // Break it up
    partString = string_copy(rawInput, 0, CHAT_MAX_LINE_LENGTH + string_count("/:/", rawInput)*(3+COLOR_RGB_LENGTH));
    tmpString = partString;

    while string_count(" ", tmpString) > 1
    {
        // Get rid of all but the last space
        tmpString = string_copy(tmpString, string_pos(" ", tmpString)+1, string_length(tmpString));
    }
    
    // pos will be either the position of the last remaining space, or of -1 if there was no space
    pos = string_pos(" ", tmpString) + string_length(partString)-string_length(tmpString);
    
    if pos > 0
    {
        // Cut the string to the last space
        partString = string_copy(partString, 0, pos);
    }
    else
    {
        // There is no space. Just let partString be what it was
    }

    // Now find the last color code in partString
    tmpString = partString;
    while string_count("/:/", tmpString) > 1
    {
        // Get rid of all but the last color code
        tmpString = string_copy(tmpString, string_pos("/:/", tmpString)+3, string_length(tmpString));
    }
    // pos will be either the position of the last remaining color code, or of -1 if there was no color code
    pos = string_pos("/:/", tmpString)

    if pos > 0
    {
        // Save that color key to add it to the next line later
        colorKey = string_copy(tmpString, pos, 3+COLOR_RGB_LENGTH);
    }
    else
    {
        // No colorkey, default to white
        colorKey = "/:/"+COLOR_WHITE;
    }

    // Add this line of the string to the chatlog
    ds_list_add(global.chatbox.chatLog, partString);
    ds_list_add(global.chatbox.alphaLog, 320);
    // Remove the oldest message if there are too many
    while ds_list_size(global.chatbox.chatLog) > 10
    {
        ds_list_delete(global.chatbox.chatLog, 0);
        ds_list_delete(global.chatbox.alphaLog, 0);
    }

    // Subtract this line from the rest of the message
    rawInput = string_copy(rawInput, string_length(partString)+1, string_length(rawInput));// +1 = space that was replaced by a newline
    // Add the color key as well
    rawInput = colorKey + rawInput;
}

// Add the last line of the string to the chatlog
ds_list_add(global.chatbox.chatLog, rawInput);
ds_list_add(global.chatbox.alphaLog, 320);
// Remove the oldest message if there are too many
while ds_list_size(global.chatbox.chatLog) > 10
{
    ds_list_delete(global.chatbox.chatLog, 0);
    ds_list_delete(global.chatbox.alphaLog, 0);
}
