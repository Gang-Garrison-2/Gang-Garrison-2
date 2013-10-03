// Clears up contents of an httpClient prior to destruction or after error

socket_destroy(socket);
buffer_destroy(responseBody);
ds_map_destroy(responseHeaders);
ds_map_destroy(requestUrlParts);
