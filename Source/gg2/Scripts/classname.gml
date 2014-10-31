//Usage: classname(class)
//Example: classname(CLASS_SPY) - Returns "Infiltrator"
//Returns: Gang Garrison 2 name of the class (By ID/constant)

var classStr, class;
classStr = "Unknown";
class = argument0;

switch (class)
{
    case CLASS_SCOUT: classStr = "Runner"; break;
    case CLASS_SOLDIER: classStr = "Rocketman"; break;
    case CLASS_SNIPER: classStr = "Rifleman"; break;
    case CLASS_DEMOMAN: classStr = "Detonator"; break;
    case CLASS_MEDIC: classStr = "Healer"; break;
    case CLASS_ENGINEER: classStr = "Constructor"; break;
    case CLASS_HEAVY: classStr = "Overweight"; break;
    case CLASS_SPY: classStr = "Infiltrator"; break;
    case CLASS_PYRO: classStr = "Firebug"; break;
    case CLASS_QUOTE: classStr = "Querly"; break;
}

return classStr;
