// Gets the error message of an HTTP request
// string httpRequestError(real client)

// client - HttpClient object

// Return value is a string describing the error

// This is *not* the "error message" accompanying the status code.
// See httpRequestReasonPhrase for that

var client;
client = argument0;

return client.error;
