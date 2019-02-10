ds_list_clear(global.map_rotation);
if ((global.mapRotationFile != "") and file_exists(global.mapRotationFile))
{
    var fileHandle, i, mapname;
    fileHandle = file_text_open_read(global.mapRotationFile);
    for (i = 1; !file_text_eof(fileHandle); i += 1)
    {
        mapname = trim(file_text_read_string(fileHandle));
        if (mapname != "" and string_char_at(mapname, 0) != "#") // if it's not blank and it's not a comment (starting with #)
        {
            ds_list_add(global.map_rotation, mapname);
        }
        file_text_readln(fileHandle);
    }
    file_text_close(fileHandle);
}
else
{
    ds_list_copy(global.map_rotation, global.ini_map_rotation);
}
