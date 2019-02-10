var LIMIT;
LIMIT = 30;

if (argument0 == "")
    return "None (map order from gg2.ini)";
else if (string_length(argument0) <= LIMIT)
    return argument0;
else
    return "..." + string_copy(argument0, string_length(argument0)-(LIMIT-3-1), LIMIT-3);
