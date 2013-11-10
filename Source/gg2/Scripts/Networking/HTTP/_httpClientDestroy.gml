// Clears up contents of an httpClient prior to destruction or after error

if (!destroyed) {
    socket_destroy(socket);
    buffer_destroy(responseBody);
    ds_map_destroy(responseHeaders);
}
destroyed = true;
