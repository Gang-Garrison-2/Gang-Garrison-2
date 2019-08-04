// checks the name of a plugin to see if it conforms to /[a-z0-9_]+/
// returns true is it conforms, false if otherwise
// argument0 - plugin name

var i, validChars;

if (string_length(argument0) < 1)
{
    return false;
}

validChars = "0123456789abcdefghijklmnopqrstuvwxyz_";
for (i = 1; i <= string_length(argument0); i+=1)
{
    // if the current character isn't valid
    if (string_pos(string_char_at(argument0, i), validChars) == 0)
    {
        return false;
    }
}

return true;
