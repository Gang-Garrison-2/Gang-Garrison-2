 {
    //argument0: time since the healtarget has taken damage
    var time, firstThreshold, secondThreshold, lastThreshold;
    time = argument0;
    firstThreshold = 5 * 30;
    lastThreshold = 8 * 30;
    
    if (time < firstThreshold) return 1;    
    else if (time > lastThreshold) return 3;
    else return ((time-firstThreshold)*2 / (secondThreshold-firstThreshold)) + 1;
}
