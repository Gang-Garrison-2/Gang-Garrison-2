// getRelativePathIfDescendand(startPath, endPath)
// Determines a relative path for endPath that is relative to startPath, if endPath is inside of startPath or a subdirectory of startPath.
// Otherwise returns endPath as an absolute path.
// startPath and endPath must be absolute paths.
// startPath must be a directory and must include a trailing slash e.g. working_directory + "\".
// Path segment delimiters are converted to forward slashes.

var startPath, endPath;
startPath = string_replace_all(argument0, "\", "/");
endPath = string_replace_all(argument1, "\", "/");

if (string_char_at(startPath, string_length(startPath)) != "/") {
    show_error("Starting path must end with a slash, but the given starting path was " + argument0 + ". Please report this problem.", true);
}

// If startPath is not a prefix of endPath, return the absolute endPath
if (string_copy(endPath, 1, string_length(startPath)) != startPath) {
    return endPath;
} else {
    return string_delete(endPath, 1, string_length(startPath));
}
