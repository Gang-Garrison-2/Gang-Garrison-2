// argument0 - name of the map to compute the md5 for

// returns the md5, or "" if there was a problem (no map file, or some other problem)

{
    if(!file_exists("Maps/" + argument0 + ".png")) {
        return "";
        exit;
    }
    return GG2DLL_compute_MD5("Maps/" + argument0 + ".png");
}