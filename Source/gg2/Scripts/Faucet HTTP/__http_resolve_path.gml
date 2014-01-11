// ***
// This function forms part of Faucet HTTP v1.0
// https://github.com/TazeTSchnitzel/Faucet-HTTP-Extension
// 
// Copyright (c) 2013-2014, Andrea Faulds <ajf@ajf.me>
// 
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
// 
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
// ***

// Takes a base path and a path reference and applies it to the base path
// Returns resulting absolute path
// string __http_resolve_path(string basePath, string refPath)

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
parts = __http_split(basePath, '/', 0);
refParts = __http_split(refPath, '/', 0);

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
