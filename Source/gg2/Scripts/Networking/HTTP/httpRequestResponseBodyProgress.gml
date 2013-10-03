// Gets the size of response body returned by an HTTP request which is so far downloaded 
// real httpRequestResponseBodyProgress(real client)

// client - HttpClient object

// Return value is the size in bytes, or -1 if we haven't started yet or client has errored

var client;
client = argument0;

return client.responseBodyProgress;
