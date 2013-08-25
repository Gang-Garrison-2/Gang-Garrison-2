// Cleans up HttpClient
// void httpRequestResponseBody(real client)

// client - HttpClient object

var client;
client = argument0;

with (client)
{
    _httpClientDestroy();
    instance_destroy();
}
