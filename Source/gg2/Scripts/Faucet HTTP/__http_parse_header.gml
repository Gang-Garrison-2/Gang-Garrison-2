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

// Internal function - parses header
// real __http_parse_header(string linebuf, real line)
// Returns false if it errored (caller should return and destroy)

var linebuf, line;
linebuf = argument0;
line = argument1;

// "HTTP/1.1 header field values can be folded onto multiple lines if the
// continuation line begins with a space or horizontal tab."
if ((string_char_at(linebuf, 1) == ' ' or ord(string_char_at(linebuf, 1)) == 9))
{
    if (line == 1)
    {
        errored = true;
        error = "First header line of response can't be a continuation, right?";
        return false;
    }
    headerValue = ds_map_find_value(responseHeaders, string_lower(headerName))
        + string_copy(linebuf, 2, string_length(linebuf) - 1);
}
// "Each header field consists
// of a name followed by a colon (":") and the field value. Field names
// are case-insensitive. The field value MAY be preceded by any amount
// of LWS, though a single SP is preferred."
else
{
    var colonPos;
    colonPos = string_pos(':', linebuf);
    if (colonPos == 0)
    {
        errored = true;
        error = "No colon in a header line of response";
        return false;
    }
    headerName = string_copy(linebuf, 1, colonPos - 1);
    headerValue = string_copy(linebuf, colonPos + 1, string_length(linebuf) - colonPos);
    // "The field-content does not include any leading or trailing LWS:
    // linear white space occurring before the first non-whitespace
    // character of the field-value or after the last non-whitespace
    // character of the field-value. Such leading or trailing LWS MAY be
    // removed without changing the semantics of the field value."
    while (string_char_at(headerValue, 1) == ' ' or ord(string_char_at(headerValue, 1)) == 9)
        headerValue = string_copy(headerValue, 2, string_length(headerValue) - 1);
}

ds_map_add(responseHeaders, string_lower(headerName), headerValue);

if (string_lower(headerName) == 'content-length')
{
    responseBodySize = real(headerValue);
    responseBodyProgress = 0;
}

return true;
