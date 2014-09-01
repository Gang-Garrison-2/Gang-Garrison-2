// real/string ggon_decode(real tokens)
// Decodes a tokenised GGON (Gang Garrison Object Notation) text ds_queue
// Returns either a string or a ds_map handle

var tokens;
tokens = argument0;

var tokenType, tokenValue;
while (!ds_queue_empty(tokens))
{
    tokenType = ds_queue_dequeue(tokens);
    tokenValue = ds_queue_dequeue(tokens);
    
    if (tokenType == 'string')
        return tokenValue;
    
    if (tokenType == 'punctuation')
    {
        // GGON has only two primitives - it could only be string or opening {
        if (tokenValue != '{')
            show_error('Error when parsing GGON: unexpected token "' + tokenValue + '"', true);
        
        var map;
        map = ds_map_create();
        
        tokenType = ds_queue_head(tokens);
        if (tokenType == 'punctuation')
        {
            tokenType = ds_queue_dequeue(tokens);
            tokenValue = ds_queue_dequeue(tokens);
            
            // { can only be followed by } or a key
            if (tokenValue != '}')
                show_error('Error when parsing GGON: unexpected token "' + tokenValue + '" after opening {', true);
            
            // It's {} so we can just return our empty map
            return map;
        }
        else if (tokenType == 'string')
        {
            // Parse each key of our map
            while (!ds_queue_empty(tokens))
            {
                tokenType = ds_queue_dequeue(tokens);
                tokenValue = ds_queue_dequeue(tokens);
                
                var key;
                key = tokenValue;
                
                tokenType = ds_queue_dequeue(tokens);
                tokenValue = ds_queue_dequeue(tokens);
                
                // Following token must be a : as we have a key
                if (tokenType != 'punctuation')
                    show_error('Error when parsing GGON: unexpected ' + tokenType + ' after key', true);
                if (tokenValue != ':')
                    show_error('Error when parsing GGON: unexpected token "' + tokenValue + '" after key', true);
                    
                // Now we recurse to parse our value!
                var value;
                value = ggon_parse_tokens(tokens);
                
                ds_map_add(map, key, value);
                
                tokenType = ds_queue_dequeue(tokens);
                tokenValue = ds_queue_dequeue(tokens);
                
                // After key, colon and value, next token must be , or }
                if (tokenType != 'punctuation')
                    show_error('Error when parsing GGON: unexpected ' + tokenType + ' after value', true);
                if (tokenValue == ',')
                    continue;
                else if (tokenValue == '}')
                    return map;
                else
                    show_error('Error when parsing GGON: unexpected token "' + tokenValue + '" after value', true);
            }
        }
        else
            show_error('Error when parsing GGON: unknown token type "' + tokenType + '"', true);
    }
    
    show_error('Error when parsing GGON: unknown token type "' + tokenType + '"', true);
}
