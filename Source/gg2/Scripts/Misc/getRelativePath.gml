//Returns a relative path from the first to the second absolute ones
//Starting absolute path, typically program_directory - argument0
//Ending absolute path - argument1
//Uses forward slash as file delimiter
var startPath, endPath, returnPath, goBack, fromLastSlash;
startPath = string_replace_all(argument0, "\", "/");
endPath = string_replace_all(argument1, "\", "/");
returnPath = "";
fromLastSlash = "";

//Compare first chars and delete them if they're the same
while(string_char_at(startPath, 1) == string_char_at(endPath, 1)) {

    if (string_char_at(startPath, 1) == "/")
        fromLastSlash = string_delete(startPath, 1, 1);

    startPath = string_delete(startPath, 1, 1);
    endPath = string_delete(endPath, 1, 1);
}

goBack = string_count("/", startPath);

repeat(goBack) {
    returnPath += "../";
}
returnPath += fromLastSlash;

return returnPath;