    // Prints the given argument to the console, while also deleting old stuff.
    // Note: The name is from a plugin convention
    // argument0 = what should be printed.
    // argument1 = The log we're appending to
     
    var input, log;
    input = argument0;
    // String is too long, break it in pieces and print each on a separate line
    
    while string_length(input) > 84
    {
        var position, tempString, oldPosition, prefix;
       
        position = 0
        oldPosition = 0
        tempString = string_copy(input, 0, 83)
     
        if string_count(" ", tempString) != 0// Break the line at spaces if possible
        {
            while string_count(" ", tempString) > 0
            {
                position = string_pos(" ", tempString)
                oldPosition += position
                tempString = string_copy(tempString, position+1, string_length(tempString))
            }
           
            ds_list_add(global.consoleLog, string_copy(input, 0, oldPosition));
            prefix = string_copy(input, 0, 3 + COLOR_RGB_LENGTH)
            input = string_copy(input, oldPosition+1, string_length(input));
     
            if string_copy(prefix, 0, 3) == "/:/"// A color code was there, prepend this to the next line too
            {
                input = prefix+input
            }
     
        }
        else// Just break it normally if there are no spaces
        {
            ds_list_add(global.consoleLog, string_copy(input, 0, 83));
            prefix = string_copy(input, 0, 3 + COLOR_RGB_LENGTH)
            input = string_copy(input, 84, string_length(input));
     
            if string_copy(prefix, 0, 3) == "/:/"// A color code was there, prepend this to the next line too
            {
                input = prefix+input
            }
        }
        
    }
    
    ds_list_add(global.consoleLog, input);
    // This console can hold a maximum number of 32 lines of text
    while ds_list_size(global.consoleLog) > 32
    {
        ds_list_delete(global.consoleLog, 0)
    }

