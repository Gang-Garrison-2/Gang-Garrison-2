// Makes a GET HTTP request
// real httpRequestGet(string url, real headers[, real overwrite])

// url - URL to send GET request to
// headers - ds_map of extra headers to send, -1 if none

// Return value is an HttpClient instance that can be passed to httpRequestStatus etc.
// (errors on failure to parse URL)

var url, headers, client;

url = argument0;
headers = argument1;

client = instance_create(0, 0, HttpClient);
_httpPrepareRequest(client, url, headers);
return client;
