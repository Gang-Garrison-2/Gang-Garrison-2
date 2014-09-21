// real ggon_tokenise(string text)
// Tokenises a GGON (Gang Garrison Object Notation) text
// Returns a ds_queue of tokens
// For each token, list has type ("punctuation" or "string") and value
// Thus you must iterate over the list two elements at a time

var text;
text = argument0;

var tokens;
tokens = ds_queue_create();

while (string_length(text) > 0)
{
    var char;
    char = string_char_at(text, 1);

    // basic punctuation: '{', '}', ':' and ','
    if (char == '{' or char == '}' or char == ':' or char == ',')
    {
        ds_queue_enqueue(tokens, 'punctuation');
        ds_queue_enqueue(tokens, char);
        text = string_copy(text, 2, string_length(text) - 1);
        continue;
    }
    
    // skip whitespace (space, tab, new line or carriage return)
    if (char == ' ' or char == chr(9) or char == chr(10) or char == chr(13))
    {
        text = string_copy(text, 2, string_length(text) - 1);
        continue;
    }
    
    // "identifiers" (bare word strings, really) of format [a-zA-Z0-9_]+
    if (('a' <= char and char <= 'z') or ('A' <= char and char <= 'Z') or ('0' <= char and char <= '9') or char == '_' or char == '.' or char == '+' or char == '-')
    {
        var identifier;
        identifier = '';
        while (('a' <= char and char <= 'z') or ('A' <= char and char <= 'Z') or ('0' <= char and char <= '9') or char == '_' or char == '.' or char == '+' or char == '-')
        {
            if (string_length(text) == 0)
                show_error('Error when tokenising GGON: unexpected end of text while parsing string', true);
            identifier += char;
            text = string_copy(text, 2, string_length(text) - 1);
            char = string_char_at(text, 1);
        }
        ds_queue_enqueue(tokens, 'string');
        ds_queue_enqueue(tokens, identifier);
        continue;
    }
    
    // string
    if (char == "'")
    {
        var str;
        str = '';
        text = string_copy(text, 2, string_length(text) - 1);
        char = string_char_at(text, 1);
        while (char != "'")
        {
            if (string_length(text) == 0)
                show_error('Error when tokenising GGON: unexpected end of text while parsing string', true);
            // escaping
            if (char == '\')
            {
                text = string_copy(text, 2, string_length(text) - 1);
                char = string_char_at(text, 1);
                if (char == "'" or char == '\')
                    str += char;
                // new line escape
                else if (char == 'n')
                    str += chr(10);
                // carriage return escape
                else if (char == 'r')
                    str += chr(13);
                // tab escape
                else if (char == 't')
                    str += chr(9);
                // null byte escape
                else if (char == '0')
                    str += chr(0);
                else
                    show_error('Error when tokenising GGON: unknown escape sequence "\' + char + '"', true);
            }
            else
            {
                str += char;
            }
            text = string_copy(text, 2, string_length(text) - 1);
            char = string_char_at(text, 1);
        }
        if (char != "'")
            show_error('Error when tokenising GGON: unexpected character "' + char + '" while parsing string, expected "' + "'" + '"', true);
        text = string_copy(text, 2, string_length(text) - 1);
        char = string_char_at(text, 1);
        
        ds_queue_enqueue(tokens, 'string');
        ds_queue_enqueue(tokens, str);
        continue;
    }
    
    show_error('Error when tokenising GGON: unexpected character "' + char + '"', true);
}

return tokens;
