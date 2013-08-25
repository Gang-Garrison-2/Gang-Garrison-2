// Makes a GET HTTP request
// real httpRequestGet(string url, real headers[, real overwrite])

// url - URL to send GET request to
// headers - ds_map of extra headers to send, -1 if none
// overwrite - optional, overwrites properties of existing object instead of creating new

// Return value is an HttpClient instance that can be passed to httpRequestStatus etc.
// (errors on failure to parse URL)

var url, headers;
url = argument0;
headers = argument1;
overwrite = argument2;

var parsed;
parsed = httpParseUrl(url);

if (parsed == -1)
    show_error("Error when making HTTP GET request - can't parse URL: " + url, true);

if (!ds_map_exists(parsed, 'port'))
    ds_map_add(parsed, 'port', 80);
if (!ds_map_exists(parsed, 'path'))
    ds_map_add(parsed, 'path', '/');

var client;
if (overwrite != 0)
    client = overwrite;
else
    client = instance_create(0, 0, HttpClient);
client.CR = chr(13);
client.LF = chr(10);
client.CRLF = client.CR + client.LF;
client.socket = tcp_connect(ds_map_find_value(parsed, 'host'), ds_map_find_value(parsed, 'port'));
client.state = 0;
client.errored = false;
client.error = '';
client.linebuf = '';
client.line = 0;
client.statusCode = -1;
client.reasonPhrase = '';
client.responseBody = buffer_create();
client.responseBodySize = -1;
client.responseBodyProgress = -1;
client.responseHeaders = ds_map_create();
client.requestUrl = url;
client.requestUrlParts = parsed;
client.requestHeaders = headers;

with (client)
{
    if (ds_map_exists(parsed, 'query'))
        write_string(socket, 'GET ' + ds_map_find_value(parsed, 'path') + '?' + ds_map_find_value(parsed, 'query') + ' HTTP/1.1' + CRLF);
    else
        write_string(socket, 'GET ' + ds_map_find_value(parsed, 'path') + ' HTTP/1.1' + CRLF);
    write_string(socket, 'Host: ' + ds_map_find_value(parsed, 'fullhost') + CRLF);
    write_string(socket, 'Connection: close' + CRLF);
    
    // If headers specified
    if (headers != -1)
    {
        var key;
        // Iterate over headers map
        for (key = ds_map_find_first(headers); key != 0; key = ds_map_find_next(headers, key))
        {
            write_string(socket, key + ': ' + ds_map_find_value(headers, key) + CRLF);
        }
    }
    
    // Send extra CRLF to terminate request
    write_string(socket, CRLF);
    
    socket_send(socket);
}

return client;
