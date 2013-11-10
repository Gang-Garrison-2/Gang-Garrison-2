// Takes a base path and a path reference and applies it to the base path
// Returns resulting absolute path
// string httpResolvePath(string basePath, string refPath)

// Return value is a string containing the new absolute path

// Deals with UNIX-style / paths, not Windows-style \ paths
// Can be used to clean up .. and . in non-absolute paths too ('' as basePath)

var basePath, refPath;
basePath = argument0;
refPath = argument1;

// refPath begins with '/' (is absolute), we can ignore all of basePath
if (string_char_at(refPath, 1) == '/')
{
    basePath = refPath;
    refPath = '';
}

var parts, refParts;
parts = split(basePath, '/');
refParts = split(refPath, '/');

if (refPath != '')
{
    // Find last part of base path
    var lastPart;
    lastPart = ds_list_find_value(parts, ds_list_size(parts) - 1);

    // If it's not blank (points to a file), remove it
    if (lastPart != '')
    {
        ds_list_delete(parts, ds_list_size(parts) - 1);
    }
    
    // Concatenate refParts to end of parts
    var i;
    for (i = 0; i < ds_list_size(refParts); i += 1)
        ds_list_add(parts, ds_list_find_value(refParts, i));
}

// We now don't need refParts any more
ds_list_destroy(refParts);

// Deal with '..' and '.'
for (i = 0; i < ds_list_size(parts); i += 1)
{
    var part;
    part = ds_list_find_value(parts, i);

    if (part == '.')
    {
        if (i == 1 or i == ds_list_size(parts) - 1)
            ds_list_replace(parts, i, '');
        else
            ds_list_delete(parts, i);
        i -= 1;
        continue;
    }
    else if (part == '..')
    {
        if (i > 1)
        {
            ds_list_delete(parts, i - 1);
            ds_list_delete(part, i);
            i -= 2;
        }
        else
        {
            ds_list_replace(parts, i, '');
            i -= 1;
        }
        continue;
    }
    else if (part == '' and i != 0 and i != ds_list_size(parts) - 1)
    {
        ds_list_delete(parts, i);
        i -= 1;
        continue;
    }
}

// Reconstruct path from parts
var path;
path = '';
for (i = 0; i < ds_list_size(parts); i += 1)
{
    if (i != 0)
        path += '/';
    path += ds_list_find_value(parts, i);
}

ds_map_destroy(parts);
return path;
