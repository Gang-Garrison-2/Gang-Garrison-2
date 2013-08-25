// Gets the response headers returned by an HTTP request as a ds_map
// real httpRequestResponseHeaders(real client)

// client - HttpClient object

// Return value is a ds_map if client hasn't errored and is finished

// All headers will have lowercase keys

var client;
client = argument0;

return client.responseHeaders;
