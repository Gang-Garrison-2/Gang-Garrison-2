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

// Steps the HTTP client (needs to be called each step or so)

var client;
client = argument0;

with (client)
{
    if (errored)
        exit;
    
    // Socket error
    if (socket_has_error(socket))
    {
        errored = true;
        error = "Socket error: " + socket_error(socket);
        return __http_client_destroy();
    }
    
    var available;
    available = tcp_receive_available(socket);
    
    switch (state)
    {
    // Receiving lines
    case 0:
        if (!available && tcp_eof(socket))
        {
            errored = true;
            error = "Unexpected EOF when receiving headers/status code";
            return __http_client_destroy();
        }
    
        var bytesRead, c;
        for (bytesRead = 1; bytesRead <= available; bytesRead += 1)
        {
            c = read_string(socket, 1);
            // Reached end of line
            // "HTTP/1.1 defines the sequence CR LF as the end-of-line marker for all
            // protocol elements except the entity-body (see appendix 19.3 for
            // tolerant applications)."
            if (c == LF and string_char_at(linebuf, string_length(linebuf)) == CR)
            {
                // Strip trailing CR
                linebuf = string_copy(linebuf, 1, string_length(linebuf) - 1);
                // First line - status code
                if (line == 0)
                {
                    // "The first line of a Response message is the Status-Line, consisting
                    // of the protocol version followed by a numeric status code and its
                    // associated textual phrase, with each element separated by SP
                    // characters. No CR or LF is allowed except in the final CRLF sequence."
                    var httpVer, spacePos;
                    spacePos = string_pos(' ', linebuf);
                    if (spacePos == 0)
                    {
                        errored = true;
                        error = "No space in first line of response";
                        return __http_client_destroy();
                    }
                    httpVer = string_copy(linebuf, 1, spacePos);
                    linebuf = string_copy(linebuf, spacePos + 1, string_length(linebuf) - spacePos);
    
                    spacePos = string_pos(' ', linebuf);
                    if (spacePos == 0)
                    {
                        errored = true;
                        error = "No second space in first line of response";
                        return __http_client_destroy();
                    }
                    statusCode = real(string_copy(linebuf, 1, spacePos));
                    reasonPhrase = string_copy(linebuf, spacePos + 1, string_length(linebuf) - spacePos);
                }
                // Other line
                else
                {
                    // Blank line, end of response headers
                    if (linebuf == '')
                    {
                        state = 1;
                        // write remainder
                        write_buffer_part(responseBody, socket, available - bytesRead);
                        responseBodyProgress = available - bytesRead;
                        break;
                    }
                    // Header
                    else
                    {
                        if (!__http_parse_header(linebuf, line))
                            return __http_client_destroy();
                    }
                }
    
                linebuf = '';
                line += 1;
            }
            else
                linebuf += c;
        }
        break;
    // Receiving response body
    case 1:
        write_buffer(responseBody, socket);
        responseBodyProgress += available;
        if (tcp_eof(socket))
        {
            if (ds_map_exists(responseHeaders, 'transfer-encoding'))
            {
                if (ds_map_find_value(responseHeaders, 'transfer-encoding') == 'chunked')
                {
                    // Chunked transfer, let's decode it
                    var actualResponseBody, actualResponseSize;
                    actualResponseBody = buffer_create();
                    actualResponseBodySize = 0;

                    // Parse chunks
                    // chunk          = chunk-size [ chunk-extension ] CRLF
                    //                  chunk-data CRLF
                    // chunk-size     = 1*HEX
                    while (buffer_bytes_left(responseBody))
                    {
                        var chunkSize, c;
                        chunkSize = '';
                        
                        // Read chunk size byte by byte 
                        while (buffer_bytes_left(responseBody))
                        {
                            c = read_string(responseBody, 1);
                            if (c == CR or c == ';')
                                break;
                            else
                                chunkSize += c;
                        }
                        
                        // We found a semicolon - beginning of chunk-extension
                        if (c == ';')
                        {
                            // skip all extension stuff
                            while (buffer_bytes_left(responseBody) && c != CR)
                            {
                                c = read_string(responseBody, 1);
                            }
                        }
                        // Reached end of header
                        if (c == CR)
                        {
                            c += read_string(responseBody, 1);
                            // Doesn't end in CRLF
                            if (c != CRLF)
                            {
                                errored = true;
                                error = 'header of chunk in chunked transfer did not end in CRLF';
                                buffer_destroy(actualResponseBody);
                                return __http_client_destroy();
                            }
                            // chunk-size is empty - something's up!
                            if (chunkSize == '')
                            {
                                errored = true;
                                error = 'empty chunk-size in a chunked transfer';
                                buffer_destroy(actualResponseBody);
                                return __http_client_destroy();
                            }
                            chunkSize = __http_parse_hex(chunkSize);
                            // Parsing of size failed - not hex?
                            if (chunkSize == -1)
                            {
                                errored = true;
                                error = 'chunk-size was not hexadecimal in a chunked transfer';
                                buffer_destroy(actualResponseBody);
                                return __http_client_destroy();
                            }
                            // Is the chunk bigger than the remaining response?
                            if (chunkSize + 2 > buffer_bytes_left(responseBody))
                            {
                                errored = true;
                                error = 'chunk-size was greater than remaining data in a chunked transfer';
                                buffer_destroy(actualResponseBody);
                                return __http_client_destroy();
                            }
                            // OK, everything's good, read the chunk
                            write_buffer_part(actualResponseBody, responseBody, chunkSize);
                            actualResponseBodySize += chunkSize;
                            // Check for CRLF
                            if (read_string(responseBody, 2) != CRLF)
                            {
                                errored = true;
                                error = 'chunk did not end in CRLF in a chunked transfer';
                                return __http_client_destroy();
                            }
                        }
                        else
                        {
                            errored = true;
                            error = 'did not find CR after reading chunk header in a chunked transfer, Faucet HTTP bug?';
                            return __http_client_destroy();
                        }
                        // if the chunk size is zero, then it was the last chunk
                        if (chunkSize == 0
                            // trailer headers will be present
                            and ds_map_exists(responseHeaders, 'trailer'))
                        {
                            // Parse header lines
                            var line;
                            line = 1;
                            while (buffer_bytes_left(responseBody))
                            {
                                var linebuf;
                                linebuf = '';
                                while (buffer_bytes_left(responseBody))
                                {
                                    c = read_string(responseBody, 1);
                                    if (c != CR)
                                        linebuf += c;
                                    else
                                        break;
                                }
                                c += read_string(responseBody, 1);
                                if (c != CRLF)
                                {
                                    errored = true;
                                    error = 'trailer header did not end in CRLF in a chunked transfer';
                                    return __http_client_destroy();
                                }
                                if (!__http_parse_header(linebuf, line))
                                    return __http_client_destroy();
                                line += 1;
                            }
                        }
                    }
                    responseBodySize = actualResponseBodySize;
                    buffer_destroy(responseBody);
                    responseBody = actualResponseBody;
                }
                else
                {
                    errored = true;
                    error = 'Unsupported Transfer-Encoding: "' + ds_map_find_value(responseHaders, 'transfer-encoding') + '"';
                    return __http_client_destroy();
                }
            }
            else if (responseBodySize != -1)
            {
                if (responseBodyProgress < responseBodySize)
                {
                    errored = true;
                    error = "Unexpected EOF, response body size is less than expected";
                    return __http_client_destroy();
                }
            }
            // 301 Moved Permanently/302 Found/303 See Other/307 Moved Temporarily
            if (statusCode == 301 or statusCode == 302 or statusCode == 303 or statusCode == 307)
            {
                if (ds_map_exists(responseHeaders, 'location'))
                {
                    var location, resolved;
                    location = ds_map_find_value(responseHeaders, 'location');
                    resolved = __http_resolve_url(requestUrl, location);
                    // Resolving URL didn't fail and it's http://
                    if (resolved != '' and string_copy(resolved, 1, 7) == 'http://')
                    {
                        // Restart request
                        __http_client_destroy();
                        __http_prepare_request(client, resolved, requestHeaders);
                    }
                    else
                    {
                        errored = true;
                        error = "301, 302, 303 or 307 response with invalid or unsupported Location URL ('" + location +  "') - can't redirect";
                        return __http_client_destroy();
                    }
                    exit;
                }
                else
                {
                    errored = true;
                    error = "301, 302, 303 or 307 response without Location header - can't redirect";
                    return __http_client_destroy();
                }
            }
            else
                state = 2;
        }
        break;
    // Done.
    case 2:
        break;
    }
}
