// Gets the status code returned by an HTTP request
// real httpRequestStatusCode(real client)

// client - HttpClient object

// Return value is either the status code of the request, or -1 if errored/not done yet

// "The Status-Code element is a 3-digit integer result code of the
// attempt to understand and satisfy the request. These codes are fully
// defined in section 10. The Reason-Phrase is intended to give a short
// textual description of the Status-Code. The Status-Code is intended
// for use by automata and the Reason-Phrase is intended for the human
// user. The client is not required to examine or display the Reason-
// Phrase."

var client;
client = argument0;

return client.statusCode;
