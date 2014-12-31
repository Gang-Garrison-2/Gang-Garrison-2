// real/string ggon_decode(real tokens)
// Decodes a tokenised GGON (Gang Garrison Object Notation) text ds_queue
// Returns either a string or a ds_map handle

var tokens;
tokens = argument0;

var token;
while (!ds_queue_empty(tokens))
{
    token = ds_queue_dequeue(tokens);
    
    // String
    if (string_char_at(token, 1) == '%')
        return string_copy(token, 2, string_length(token) - 1);
    
    // GGON has only three primitives - it could only be string, opening { or opening [
    if (token != '{' and token != '[')
        show_error('Error when parsing GGON: unexpected token "' + token + '"', true);
    
    // Either way it decodes to a map
    var map;
    map = ds_map_create();
        
    // GGON map
    if (token == '{')
    {
        token = ds_queue_head(tokens);
        if (token == '}')
        {
            ds_queue_dequeue(tokens);
            
            // It's {} so we can just return our empty map
            return map;
        }
        // string
        else if (string_char_at(token, 1) == '%')
        {
            // Parse each key of our map
            while (!ds_queue_empty(tokens))
            {
                token = ds_queue_dequeue(tokens);
                
                var key;
                key = string_copy(token, 2, string_length(token) - 1);
                
                token = ds_queue_dequeue(tokens);
                
                // Following token must be a : as we have a key
                if (token != ':')
                    show_error('Error when parsing GGON: unexpected token "' + token + '" after key', true);
                    
                // Now we recurse to parse our value!
                var value;
                value = ggon_parse_tokens(tokens);
                
                ds_map_add(map, key, value);
                
                token = ds_queue_dequeue(tokens);
                
                // After key, colon and value, next token must be , or }
                if (token == ',')
                    continue;
                else if (token == '}')
                    return map;
                else
                    show_error('Error when parsing GGON: unexpected token "' + token + '" after value', true);
            }
        }
        else
            show_error('Error when parsing GGON: unexpected token "' + token + '"', true);
    }
    // GGON list
    else
    {
        token = ds_queue_head(tokens);

        if (token == ']')
        {
            ds_queue_dequeue(tokens);
        
            // It's an empty list
            ds_map_add(map, "length", "0");
            return map;
        }
        else
        {
            var length;
            length = 0;
            
            // Parse each value in our list
            while (!ds_queue_empty(tokens))
            { 
                // Now we recurse to parse our value!
                var value;
                value = ggon_parse_tokens(tokens);
                
                ds_map_add(map, string(length), value);
                length += 1;
                
                token = ds_queue_dequeue(tokens);
                
                // After value, next token must be , or ]
                if (token == ',')
                    continue;
                else if (token == ']')
                {
                    ds_map_add(map, "length", string(length));
                    return map;
                }
                else
                    show_error('Error when parsing GGON: unexpected token "' + token + '" after value', true);
            }
        }
    }
}
