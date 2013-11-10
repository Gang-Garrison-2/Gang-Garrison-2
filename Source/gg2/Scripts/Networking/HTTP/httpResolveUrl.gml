// Takes a base URL and a URL reference and applies it to the base URL
// Returns resulting absolute URL
// string httpResolveUrl(string baseUrl, string refUrl)

// Return value is a string containing the new absolute URL, or "" on failure

// Works only for restricted URL syntax as understood by by httpResolveUrl
// The sole restriction of which is that only scheme://authority/path URLs work
// This notably excludes file: URLs which lack the authority component

// As described by RFC3986:
//      URI-reference = URI / relative-ref
//      relative-ref  = relative-part [ "?" query ] [ "#" fragment ]
//      relative-part = "//" authority path-abempty
//                    / path-absolute
//                    / path-noscheme
//                    / path-empty
// However httpResolveUrl does *not* deal with fragments

// Algorithm based on that of section 5.2.2 of RFC 3986

var baseUrl, refUrl;
baseUrl = argument0;
refUrl = argument1;

// Parse base URL
var urlParts;
urlParts = httpParseUrl(baseUrl);
if (urlParts == -1)
    return '';

// Try to parse reference URL
var refUrlParts, canParseRefUrl;
refUrlParts = httpParseUrl(refUrl);
canParseRefUrl = (refUrlParts != -1);
if (refUrlParts != -1)
    ds_map_destroy(refUrlParts);

var result;
result = '';

// Parsing of reference URL succeeded - it's absolute and we're done
if (canParseRefUrl)
{
    result = refUrl;
}
// Begins with '//' - scheme-relative URL
else if (string_copy(refUrl, 1, 2) == '//' and string_length(refUrl) > 2)
{
    result = ds_map_find_value(urlParts, 'scheme') + ':' + refUrl;
}
// Is or begins with '/' - absolute path relative URL
else if (((string_char_at(refUrl, 1) == '/' and string_length(refUrl) > 1) or refUrl == '/')
// Doesn't begin with ':' and is not blank - relative path relative URL
    or (string_char_at(refUrl, 1) != ':' and string_length(refUrl) > 0)) 
{
    // Find '?' for query
    var queryPos;
    queryPos = string_pos('?', refUrl);
    // No query
    if (queryPos == 0)
    {
        refUrl = httpResolvePath(ds_map_find_value(urlParts, 'abs_path'), refUrl);
        ds_map_replace(urlParts, 'abs_path', refUrl);
        if (ds_map_exists(urlParts, 'query'))
            ds_map_delete(urlParts, 'query');
    }
    // Query exists, split
    else
    {
        var path, query;
        path = string_copy(refUrl, 1, queryPos - 1);
        query = string_copy(refUrl, queryPos + 1, string_length(relUrl) - queryPos);
        path = httpResolvePath(ds_map_find_value(urlParts, 'abs_path'), path);
        ds_map_replace(urlParts, 'abs_path', path);
        if (ds_map_exists(urlParts, 'query'))
            ds_map_replace(urlParts, 'query', query);
        else
            ds_map_add(urlParts, 'query', query);
    }
    result = httpConstructUrl(urlParts);
}

ds_map_destroy(urlParts);
return result;
