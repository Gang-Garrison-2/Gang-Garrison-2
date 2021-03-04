//Usage: classname(class)
//Example: classname(CLASS_SPY) - Returns "Infiltrator"
//Returns: Gang Garrison 2 name of the class (By ID/constant)

switch (argument0)
{
    case CLASS_SCOUT: return "Runner";
    case CLASS_SOLDIER: return "Rocketman";
    case CLASS_SNIPER: return "Rifleman";
    case CLASS_DEMOMAN: return "Detonator";
    case CLASS_MEDIC: return "Healer";
    case CLASS_ENGINEER: return "Constructor";
    case CLASS_HEAVY: return "Overweight";
    case CLASS_SPY: return "Infiltrator";
    case CLASS_PYRO: return "Firebug";
    case CLASS_QUOTE: return "Querly";
    default: return "Unknown";
}
