// Gets the response headers returned by an HTTP request as a ds_map
// real httpRequestResponseHeaders(real client)

// client - HttpClient object

// Return value is a ds_map if client hasn't errored and is finished

// All headers will have lowercase keys
// The ds_map is owned by the HttpClient, do not use ds_map_destroy() yourself
// Call when the request has finished - otherwise may be incomplete or missing

var client;
client = argument0;

return client.responseHeaders;
