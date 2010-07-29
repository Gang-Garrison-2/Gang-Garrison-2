{
    var character;
    // Argument 0: Team
    // Argument 1: Class
    
    switch(argument0*16+argument1) {
        case (TEAM_BLUE*16 + CLASS_SCOUT):
            return ScoutBlue;
        case (TEAM_BLUE*16 + CLASS_PYRO):
            return PyroBlue;
        case (TEAM_BLUE*16 + CLASS_SOLDIER):
            return SoldierBlue;
        case (TEAM_BLUE*16 + CLASS_DEMOMAN):
            return DemomanBlue;
        case (TEAM_BLUE*16 + CLASS_HEAVY):
            return HeavyBlue;
        case (TEAM_BLUE*16 + CLASS_ENGINEER):
            return EngineerBlue;
        case (TEAM_BLUE*16 + CLASS_MEDIC):
            return MedicBlue;
        case (TEAM_BLUE*16 + CLASS_SPY):
            return SpyBlue;
        case (TEAM_BLUE*16 + CLASS_SNIPER):
            return SniperBlue;
        case (TEAM_BLUE*16 + CLASS_QUOTE):
            return QuoteBlue;
            
        case (TEAM_RED*16 + CLASS_SCOUT):
            return ScoutRed;
        case (TEAM_RED*16 + CLASS_PYRO):
            return PyroRed;
        case (TEAM_RED*16 + CLASS_SOLDIER):
            return SoldierRed;
        case (TEAM_RED*16 + CLASS_DEMOMAN):
            return DemomanRed;
        case (TEAM_RED*16 + CLASS_HEAVY):
            return HeavyRed;
        case (TEAM_RED*16 + CLASS_ENGINEER):
            return EngineerRed;
        case (TEAM_RED*16 + CLASS_MEDIC):
            return MedicRed;
        case (TEAM_RED*16 + CLASS_SPY):
            return SpyRed;
        case (TEAM_RED*16 + CLASS_SNIPER):
            return SniperRed;
        case (TEAM_RED*16 + CLASS_QUOTE):
            return QuoteRed;
        default:
            return -1
    }
}