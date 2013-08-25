// Gets the current status of an HTTP request
// real httpRequestStatus(real client)

// client - HttpClient object

// Return value is either:
// 0 - In progress
// 1 - Done
// 2 - Errored

// The status being 1 and not 2 does not mean the request was successful
// So check the status code. If it is 2, it simply means there was a different error.

var client;
client = argument0;

if (client.errored)
    return 2;
else if (client.state == 2)
    return 1;
else
    return 0;
