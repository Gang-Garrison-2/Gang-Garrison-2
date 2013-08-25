// Gets the status code returned by an HTTP request
// real httpRequestStatusCode(real client)

// client - HttpClient object

// Return value is either the status code of the request, or -1 if errored/not done yet

var client;
client = argument0;

return client.statusCode;
