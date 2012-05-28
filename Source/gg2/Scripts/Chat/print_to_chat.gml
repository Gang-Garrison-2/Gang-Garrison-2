    var input, prefixLength;
    input = argument0
    if string_copy(input, 0, 3) == "/:/"// there's a color code here, so ew set the prefix length
        prefixLength = 3 + COLOR_RGB_LENGTH
    else
        prefixLength = 0
    minimumLineLength = 35 // Minimum amount of characters a line can include
    
    while string_length(input)-(prefixLength) > 41// Actual message is too long, break it in pieces and print each on a separate line
    
    {
    
        var position, message, oldPosition, prefix, colorCode, foundSpace, spaceNotAvailible;
       
        position = 0
        oldPosition = 0
        message = string_copy(input, 0, 40 + prefixLength)
        foundSpace = false
        spaceNotAvailible = false
        
        if string_count(" ", message) > 0// Break the line at spaces if possible
        {
            while string_count(" ", message) > 0 and spaceNotAvailible == false
            {
                position = 40 + prefixLength; // start at the farthest possible distance; move backwards
                while (position > minimumLineLength + prefixLength) and foundSpace == false //while we are over...
                {
                    if string_char_at(message,position) == " " and  string_char_at(message,position-1) != ":" // Attempt to circumvent the fact that Player: has a space in it.
                        foundSpace = true;
            
                    if (foundSpace == false)
                        position -= 1 //move bacck a space and redo the loop
                }
                if (foundSpace == false) { //break and do default word wrapping if no spaces availible
                    spaceNotAvailible = true;
                    break; //cut the loop
                }else{
                    oldPosition += position //set the position forward to where space is
                    message = string_copy(message, position+1, string_length(message)) //+1 for ahead of the space
           
                    ds_list_add(global.chatbox.chatLog, string_copy(input, 0, oldPosition));
                    prefix = string_copy(input, 0, prefixLength)
                    input = string_copy(input, oldPosition+1, string_length(input)); //set input to the rest of the string
 
                    if string_copy(prefix, 0, 3) == "/:/"// A color code was there, prepend this to the next line too
                        input = prefix+input
                }
            }
        }
        if string_count(" ", message) <= 1 or spaceNotAvailible == true {// Just break it normally if there are no spaces after cutting out the prefixes
            ds_list_add(global.chatbox.chatLog, string_copy(input, 0, 40+ prefixLength));
            prefix = string_copy(input, 0, prefixLength)
            input = string_copy(input, 41+ prefixLength, string_length(input));
            if string_copy(prefix, 0, 3) == "/:/"// A color code was there, prepend this to the next line too
            {
                    input = prefix+input
            }
        }
    }
     

// Add the entry to the chatbox log
if (string_length(input)-prefixLength > 0)
    ds_list_add(global.chatbox.chatLog, input);

// Delete the oldest entry if there are too many
while ds_list_size(global.chatbox.chatLog) > 10
{
    ds_list_delete(global.chatbox.chatLog, 0);
}
