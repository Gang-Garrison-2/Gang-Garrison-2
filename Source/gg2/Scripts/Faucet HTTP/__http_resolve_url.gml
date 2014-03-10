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

// Takes a base URL and a URL reference and applies it to the base URL
// Returns resulting absolute URL
// string __http_resolve_url(string baseUrl, string refUrl)

// Return value is a string containing the new absolute URL, or "" on failure

// Works only for restricted URL syntax as understood by by http_resolve_url
// The sole restriction of which is that only scheme://authority/path URLs work
// This notably excludes file: URLs which lack the authority component

// As described by RFC3986:
//      URI-reference = URI / relative-ref
//      relative-ref  = relative-part [ "?" query ] [ "#" fragment ]
//      relative-part = "//" authority path-abempty
//                    / path-absolute
//                    / path-noscheme
//                    / path-empty
// However http_resolve_url does *not* deal with fragments

// Algorithm based on that of section 5.2.2 of RFC 3986

var baseUrl, refUrl;
baseUrl = argument0;
refUrl = argument1;

// Parse base URL
var urlParts;
urlParts = __http_parse_url(baseUrl);
if (urlParts == -1)
    return '';

// Try to parse reference URL
var refUrlParts, canParseRefUrl;
refUrlParts = __http_parse_url(refUrl);
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
        refUrl = __http_resolve_path(ds_map_find_value(urlParts, 'abs_path'), refUrl);
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
        path = __http_resolve_path(ds_map_find_value(urlParts, 'abs_path'), path);
        ds_map_replace(urlParts, 'abs_path', path);
        if (ds_map_exists(urlParts, 'query'))
            ds_map_replace(urlParts, 'query', query);
        else
            ds_map_add(urlParts, 'query', query);
    }
    result = __http_construct_url(urlParts);
}

ds_map_destroy(urlParts);
return result;
