 {
    //argument0: time since the healtarget has taken damage
    var time, firstThreshold, lastThreshold;
    time = argument0;
    firstThreshold = 5 * 30;
    lastThreshold = 7.5 * 30;
    
    if (time < firstThreshold)
        return 1;    
    else if (time > lastThreshold)
        return 3;
    else return ((time-firstThreshold)*2 / (firstThreshold)) + 1;
}
