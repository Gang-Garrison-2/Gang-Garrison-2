// argument0 - name of the map to fetch the url for

// returns the url, or "" if there was a problem (no url file, or some other problem)

{
    var fileHandle, url;
    fileHandle = file_text_open_read("Maps/" + argument0 + ".locator");
    if(fileHandle == -1) {
        return "";
        exit;
    }
    url = file_text_read_string(fileHandle);
    file_text_close(fileHandle);
    return url;
}