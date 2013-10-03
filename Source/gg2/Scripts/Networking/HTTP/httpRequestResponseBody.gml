// Gets the response body returned by an HTTP request as a buffer
// real httpRequestResponseBody(real client)

// client - HttpClient object

// Return value is a buffer if client hasn't errored and is finished

var client;
client = argument0;

return client.responseBody;
