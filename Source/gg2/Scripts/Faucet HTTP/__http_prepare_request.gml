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

// Internal function - prepares request
// void __http_prepare_request(real client, string url, real headers)

// client - HttpClient object to prepare
// url - URL to send GET request to
// headers - ds_map of extra headers to send, -1 if none

var client, url, headers;
client = argument0;
url = argument1;
headers = argument2;

var parsed;
parsed = __http_parse_url(url);

if (parsed == -1)
    show_error("Error when making HTTP GET request - can't parse URL: " + url, true);

if (!ds_map_exists(parsed, 'port'))
    ds_map_add(parsed, 'port', 80);
if (!ds_map_exists(parsed, 'abs_path'))
    ds_map_add(parsed, 'abs_path', '/');

with (client)
{
    destroyed = false;
    CR = chr(13);
    LF = chr(10);
    CRLF = CR + LF;
    socket = tcp_connect(ds_map_find_value(parsed, 'host'), ds_map_find_value(parsed, 'port'));
    state = 0;
    errored = false;
    error = '';
    linebuf = '';
    line = 0;
    statusCode = -1;
    reasonPhrase = '';
    responseBody = buffer_create();
    responseBodySize = -1;
    responseBodyProgress = -1;
    responseHeaders = ds_map_create();
    requestUrl = url;
    requestHeaders = headers;

    //  Request       = Request-Line              ; Section 5.1
    //                  *(( general-header        ; Section 4.5
    //                   | request-header         ; Section 5.3
    //                   | entity-header ) CRLF)  ; Section 7.1
    //                  CRLF
    //                  [ message-body ]          ; Section 4.3

    // "The Request-Line begins with a method token, followed by the
    // Request-URI and the protocol version, and ending with CRLF. The
    // elements are separated by SP characters. No CR or LF is allowed
    // except in the final CRLF sequence."
    if (ds_map_exists(parsed, 'query'))
        write_string(socket, 'GET ' + ds_map_find_value(parsed, 'abs_path') + '?' + ds_map_find_value(parsed, 'query') + ' HTTP/1.1' + CRLF);
    else
        write_string(socket, 'GET ' + ds_map_find_value(parsed, 'abs_path') + ' HTTP/1.1' + CRLF);

    // "A client MUST include a Host header field in all HTTP/1.1 request
    // messages."
    // "A "host" without any trailing port information implies the default
    // port for the service requested (e.g., "80" for an HTTP URL)."
    if (ds_map_find_value(parsed, 'port') == 80)
        write_string(socket, 'Host: ' + ds_map_find_value(parsed, 'host') + CRLF);
    else
        write_string(socket, 'Host: ' + ds_map_find_value(parsed, 'host')
            + ':' + string(ds_map_find_value(parsed, 'port')) + CRLF);

    // "An HTTP/1.1 server MAY assume that a HTTP/1.1 client intends to
    // maintain a persistent connection unless a Connection header including
    // the connection-token "close" was sent in the request."
    write_string(socket, 'Connection: close' + CRLF);

    // "If no Accept-Encoding field is present in a request, the server MAY
    // assume that the client will accept any content coding."
    write_string(socket, 'Accept-Encoding:' + CRLF);
    
    // If headers specified
    if (headers != -1)
    {
        var key;
        // Iterate over headers map
        for (key = ds_map_find_first(headers); is_string(key); key = ds_map_find_next(headers, key))
        {
            write_string(socket, key + ': ' + ds_map_find_value(headers, key) + CRLF);
        }
    }
    
    // Send extra CRLF to terminate request
    write_string(socket, CRLF);
    
    socket_send(socket);

    ds_map_destroy(parsed);
}
