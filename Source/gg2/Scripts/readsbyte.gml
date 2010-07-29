{
    var result;
    result = readbyte(argument0);
    if(result>=128) {
        return result-256;
    } else {
        return result;
    }
}