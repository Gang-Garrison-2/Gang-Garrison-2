// Constructs an URL from its components (as httpParseUrl would return)
// string httpConstructUrl(real parts)

// Return value is the string of the constructed URL
// Keys of parts map:
// "scheme" - the URL scheme (e.g. "http")
// "host" - the hostname (e.g. "example.com" or "127.0.0.1")
// "port" - the port (e.g. 8000) - this is a real, unlike the others
// "abs_path" - the absolute path (e.g. "/" or "/index.html")
// "query" - the query string (e.g. "a=b&c=3")
// Parts which are omitted will be omitted in the URL
// e.g. http://example.com lacks "port", "path" or "query" keys

// This will *only* work properly for URLs of format:
// scheme ":" "//" host [ ":" port ] [ abs_path [ "?" query ]]"
// where [] denotes an optional component
// file: URLs will *not* work as they lack the authority (host:port) component
// Should work correctly for IPv6 host values, but bare in mind parse_url won't

var parts;
parts = argument0;

var url;
url = '';

url += ds_map_find_value(parts, 'scheme');
url += '://';
url += ds_map_find_value(parts, 'host');
if (ds_map_exists(parts, 'port'))
    url += ':' + string(ds_map_find_value(parts, 'port'));
if (ds_map_exists(parts, 'abs_path'))
{
    url += ds_map_find_value(parts, 'abs_path');
    if (ds_map_exists(parts, 'query'))
        url += '?' + ds_map_find_value(parts, 'query');
}

return url;
