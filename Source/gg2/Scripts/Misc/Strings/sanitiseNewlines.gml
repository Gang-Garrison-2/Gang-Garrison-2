// string sanitiseNewlines(string text)
// Escapes # and removes ansi_char(10) and ansi_char(13) from text
// This prevents people from being mischevious and adding newlines to names
// This should be used when DRAWING text, don't use it to "fix" people's names

var text;
text = argument0;

// Game Maker displays "#" as a newline, but "\#" as "#"
text = string_replace_all(text, "#", "\#");

// 0x10 is ASCII Line Feed, 0x13 is ASCII Carriage Return
text = string_replace_all(text, ansi_char(10), " ");
text = string_replace_all(text, ansi_char(13), " ");

return text;
