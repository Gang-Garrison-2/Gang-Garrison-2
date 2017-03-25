// real/string ggon_decode(string text)
// Decodes a GGON (Gang Garrison Object Notation) text
// Returns either a string or a ds_map handle 

var text;
text = argument0;

var tokens;
tokens = ggon_tokenise(text);

var result;
result = ggon_parse_tokens(tokens);

ds_queue_destroy(tokens);

return result;
