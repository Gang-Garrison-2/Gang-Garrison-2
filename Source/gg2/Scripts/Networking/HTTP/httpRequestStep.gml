// Steps the HTTP request (you need to call this each step or so)
// void httpRequestStep(real client)

// client - HttpClient object

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
        return _httpClientDestroy();
    }
    
    var available;
    available = tcp_receive_available(socket);
    
    switch (state)
    {
    // Receiving lines
    case 0:
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
                        return _httpClientDestroy();
                    }
                    httpVer = string_copy(linebuf, 1, spacePos);
                    linebuf = string_copy(linebuf, spacePos + 1, string_length(linebuf) - spacePos);
    
                    spacePos = string_pos(' ', linebuf);
                    if (spacePos == 0)
                    {
                        errored = true;
                        error = "No second space in first line of response";
                        return _httpClientDestroy();
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
                        var headerName, headerValue, colonPos;
                        // "HTTP/1.1 header field values can be folded onto multiple lines if the
                        // continuation line begins with a space or horizontal tab."
                        if ((string_char_at(linebuf, 1) == ' ' or ord(string_char_at(linebuf, 1)) == 9))
                        {
                            if (line == 1)
                            {
                                errored = true;
                                error = "First header line of response can't be a continuation, right?";
                                return _httpClientDestroy();
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
                            colonPos = string_pos(':', linebuf);
                            if (colonPos == 0)
                            {
                                errored = true;
                                error = "No colon in a header line of response";
                                return _httpClientDestroy();
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
            if (responseBodySize != -1)
            {
                if (responseBodyProgress < responseBodySize)
                {
                    errored = true;
                    error = "Unexpected EOF, response body size is less than expected";
                    return _httpClientDestroy();
                }
            }
            // 301 Moved Permanently/302 Found/303 See Other/307 Moved Temporarily
            if (statusCode == 301 or statusCode == 302 or statusCode == 303 or statusCode == 307)
            {
                if (ds_map_exists(responseHeaders, 'location'))
                {
                    var location;
                    location = ds_map_find_value(responseHeaders, 'location');
                    // Location is relative, absolute path
                    if (string_char_at(location, 1) == '/')
                    {
                        if (ds_map_find_value(requestUrlParsed, 'port') == 80)
                            location = 'http://' + ds_map_find_value(requestUrlParsed, 'host') + location;
                        else
                            location = 'http://' + ds_map_find_value(requestUrlParsed, 'host') 
                                + ':' + ds_map_find_value(requestUrlParsed, 'port') + location;
                        // Restart request
                        _httpClientDestroy();
                        _httpPrepareRequest(client, location, requestHeaders);
                    }
                    // Location is absolute
                    else if (string_copy(location, 1, 7) == 'http://')
                    {
                        // Restart request
                        _httpClientDestroy();
                        _httpPrepareRequest(client, location, requestHeaders);
                    }
                    else
                    {
                        errored = true;
                        error = "301, 302, 303 or 307 response with unsupported relative Location header - can't redirect";
                        return _httpClientDestroy();
                    }
                    exit;
                }
                else
                {
                    errored = true;
                    error = "301, 302, 303 or 307 response without Location header - can't redirect";
                    return _httpClientDestroy();
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
