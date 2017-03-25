var ticks, totalSeconds, minutes, seconds, secstring;
ticks = argument0;

totalSeconds = ceil(ticks/30);
minutes = totalSeconds div 60;
seconds = totalSeconds mod 60;
if (seconds >= 10)
	secstring = string(seconds);
else
	secstring = "0" + string(seconds);

return string(minutes) + ":" + secstring;