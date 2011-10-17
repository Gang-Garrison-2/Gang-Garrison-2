{
    //argument0: time since the healtarget has taken damage
    var time, firstThreshold, secondThreshold, lastThreshold;
    time = argument0;
    firstThreshold = 1 * 30;
    secondThreshold = 3 * 30;
    lastThreshold = 7 * 30;
    
    if (time < firstThreshold) return 1;    
    else if (time > lastThreshold) return 3;
    else if (time > secondThreshold) return 5/3;
    else return ((time-firstThreshold)* (5/3-1) / (secondThreshold-firstThreshold)) + 1;
}