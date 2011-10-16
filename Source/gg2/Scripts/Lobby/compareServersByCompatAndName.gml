/// Compare two Server objects by compatibility and name

if(argument0.compatible and not (argument1.compatible))
    return -1;
if(argument1.compatible and not (argument0.compatible))
    return 1;
    
var lname0, lname1;
lname0 = string_lower(argument0.name);
lname1 = string_lower(argument1.name);
if(lname0 < lname1)
    return -1;
if(lname0 > lname1)
    return 1;
    
return 0;
