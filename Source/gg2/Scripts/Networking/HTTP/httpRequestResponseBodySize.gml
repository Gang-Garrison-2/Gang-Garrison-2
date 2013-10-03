// Gets the size of response body returned by an HTTP request
// real httpRequestResponseBodySize(real client)

// client - HttpClient object

// Return value is the size in bytes, or -1 if we don't know or don't know yet

// Call this each time you use the size - it may have changed in the case of redirect

var client;
client = argument0;

return client.responseBodySize;
