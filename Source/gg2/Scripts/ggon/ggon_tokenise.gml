// real ggon_tokenise(string text)
// Tokenises a GGON (Gang Garrison Object Notation) text
// Returns a ds_queue of tokens
// Punctuation is unprefixed, so {} becomes ["{", "}"]
// Strings are prefixed with %, so {'foo': bar} becomes ["%foo", ":", "%bar"]

var text;
text = argument0;

var i, len, tokens;
i = 1;
len = string_length(text);
tokens = ds_queue_create();

while (i <= len)
{
    var char;
    char = string_char_at(text, i);
    switch (char)
    {
        // basic punctuation: '{', '}', ':', '[', ']', and ','
        case '{':
        case '}':
        case ':':
        case '[':
        case ']':
        case ',':
            ds_queue_enqueue(tokens, char);
            i += 1;
            continue;
        // skip whitespace (space, tab, new line or carriage return)
        case ' ':
        case ansi_char(9):
        case ansi_char(10):
        case ansi_char(13):
            i += 1;
            continue;
    }
    // "identifiers" (bare word strings, really) of format [a-zA-Z0-9_]+
    if (('a' <= char and char <= 'z') or ('A' <= char and char <= 'Z') or ('0' <= char and char <= '9') or char == '_' or char == '.' or char == '+' or char == '-')
    {
        var identifier;
        identifier = '';
        while (('a' <= char and char <= 'z') or ('A' <= char and char <= 'Z') or ('0' <= char and char <= '9') or char == '_' or char == '.' or char == '+' or char == '-')
        {
            if (i > len)
                show_error('Error when tokenising GGON: unexpected end of text while parsing string', true);
            identifier += char;
            i += 1;
            char = string_char_at(text, i);
        }
        ds_queue_enqueue(tokens, '%' + identifier);
        continue;
    }
    
    // string
    if (char == "'")
    {
        var str;
        str = '';
        i += 1;
        char = string_char_at(text, i);
        while (char != "'")
        {
            if (i > len)
                show_error('Error when tokenising GGON: unexpected end of text while parsing string', true);
            // escaping
            if (char == '\')
            {
                i += 1;
                char = string_char_at(text, i);
                if (char == "'" or char == '\')
                    str += char;
                // new line escape
                else if (char == 'n')
                    str += ansi_char(10);
                // carriage return escape
                else if (char == 'r')
                    str += ansi_char(13);
                // tab escape
                else if (char == 't')
                    str += ansi_char(9);
                // null byte escape
                else if (char == '0')
                    str += ansi_char(0);
                else
                    show_error('Error when tokenising GGON: unknown escape sequence "\' + char + '"', true);
            }
            else
            {
                str += char;
            }
            i += 1;
            char = string_char_at(text, i);
        }
        if (char != "'")
            show_error('Error when tokenising GGON: unexpected character "' + char + '" while parsing string, expected "' + "'" + '"', true);
        i += 1;
        char = string_char_at(text, i);
        
        ds_queue_enqueue(tokens, '%' + str);
        continue;
    }
    
    show_error('Error when tokenising GGON: unexpected character "' + char + '"', true);
}

return tokens;
