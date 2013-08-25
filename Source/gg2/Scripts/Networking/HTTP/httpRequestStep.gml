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
            if (c == LF and string_char_at(linebuf, string_length(linebuf)) == CR)
            {
                // Strip trailing CR
                linebuf = string_copy(linebuf, 1, string_length(linebuf) - 1);
                // First line - status code (of format "HTTP/X.X XXX Name"
                if (line == 0)
                {
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
                        colonPos = string_pos(':', linebuf);
                        if (colonPos == 0)
                        {
                            errored = true;
                            error = "No colon in a header line of response";
                            return _httpClientDestroy();
                        }
    
                        headerName = string_copy(linebuf, 1, colonPos - 1);
                        headerValue = string_copy(linebuf, colonPos + 1, string_length(linebuf) - colonPos);
    
                        // strip leading spaces
                        while (string_char_at(headerValue, 1) == ' ')
                            headerValue = string_copy(headerValue, 2, string_length(headerValue) - 1);
    
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
            // 301/302 Moved Temporarily/Permanently
            if (statusCode == 301 or statusCode == 302)
            {
                if (ds_map_exists(responseHeaders, 'location'))
                {
                    var location;
                    location = ds_map_find_value(responseHeaders, 'location');
                    // Location is relative, absolute path
                    if (string_char_at(location, 1) == '/')
                    {
                        location = 'http://' + ds_map_find_value(requestUrlParsed, 'fullhost') + location;
                        // Restart request
                        _httpClientDestroy();
                        httpGet(location, requestHeaders, client);
                    }
                    // Location is absolute
                    else if (string_copy(location, 1, 7) == 'http://')
                    {
                        // Restart request
                        _httpClientDestroy();
                        httpGet(location, requestHeaders, client);
                    }
                    else
                    {
                        errored = true;
                        error = "301 or 302 response with unsupported relative Location header - can't redirect";
                        return _httpClientDestroy();
                    }
                    exit;
                }
                else
                {
                    errored = true;
                    error = "301 or 302 response without Location header - can't redirect";
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
