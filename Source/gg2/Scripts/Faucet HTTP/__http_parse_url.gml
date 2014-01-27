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

// Parses a URL into its components
// real __http_parse_url(string url)

// Return value is a ds_map containing keys for the different URL parts: (or -1 on failure)
// "url" - the URL which was passed in
// "scheme" - the URL scheme (e.g. "http")
// "host" - the hostname (e.g. "example.com" or "127.0.0.1")
// "port" - the port (e.g. 8000) - this is a real, unlike the others
// "abs_path" - the absolute path (e.g. "/" or "/index.html")
// "query" - the query string (e.g. "a=b&c=3")
// Parts which are not included will not be in the map
// e.g. http://example.com will not have the "port", "path" or "query" keys

// This will *only* work properly for URLs of format:
// scheme ":" "//" host [ ":" port ] [ abs_path [ "?" query ]]"
// where [] denotes an optional component
// file: URLs will *not* work as they lack the authority (host:port) component
// It will not work correctly for IPv6 host values

var url;
url = argument0;

var map;
map = ds_map_create();
ds_map_add(map, 'url', url);

// before scheme
var colonPos;
// Find colon for end of scheme
colonPos = string_pos(':', url);
// No colon - bad URL
if (colonPos == 0)
    return -1;
ds_map_add(map, 'scheme', string_copy(url, 1, colonPos - 1));
url = string_copy(url, colonPos + 1, string_length(url) - colonPos);

// before double slash
// remove slashes (yes this will screw up file:// but who cares)
while (string_char_at(url, 1) == '/')
    url = string_copy(url, 2, string_length(url) - 1);

// before hostname
var slashPos, colonPos;
// Find slash for beginning of path
slashPos = string_pos('/', url);
// No slash ahead - http://host format with no ending slash
if (slashPos == 0)
{
    // Find : for beginning of port
    colonPos = string_pos(':', url);
}
else
{
    // Find : for beginning of port prior to /
    colonPos = string_pos(':', string_copy(url, 1, slashPos - 1));
}
// No colon - no port
if (colonPos == 0)
{
    // There was no slash
    if (slashPos == 0)
    {
        ds_map_add(map, 'host', url);
        return map;
    }
    // There was a slash
    else
    {
        ds_map_add(map, 'host', string_copy(url, 1, slashPos - 1));
        url = string_copy(url, slashPos, string_length(url) - slashPos + 1);
    }
}
// There's a colon - port specified
else
{
    // There was no slash
    if (slashPos == 0)
    {
        ds_map_add(map, 'host', string_copy(url, 1, colonPos - 1));
        ds_map_add(map, 'port', real(string_copy(url, colonPos + 1, string_length(url) - colonPos)));
        return map;
    }
    // There was a slash
    else
    {
        ds_map_add(map, 'host', string_copy(url, 1, colonPos - 1));
        url = string_copy(url, colonPos + 1, string_length(url) - colonPos);
        slashPos = string_pos('/', url);
        ds_map_add(map, 'port', real(string_copy(url, 1, slashPos - 1)));
        url = string_copy(url, slashPos, string_length(url) - slashPos + 1); 
    }
}

// before path
var queryPos;
queryPos = string_pos('?', url);
// There's no ? - no query
if (queryPos == 0)
{
    ds_map_add(map, 'abs_path', url);
    return map;
}
else
{
    ds_map_add(map, 'abs_path', string_copy(url, 1, queryPos - 1));
    ds_map_add(map, 'query', string_copy(url, queryPos + 1, string_length(url) - queryPos));
    return map;
}

// Return -1 upon unlikely error
ds_map_destroy(map);
return -1;
