// The generator of the team given in argument0 has been destroyed
var generatorToDestroy, winTeam;

if (argument0 == TEAM_RED) {
    winTeam = TEAM_BLUE;
    generatorToDestroy = GeneratorRed;
} else if (argument0 == TEAM_BLUE) {
    winTeam = TEAM_RED;
    generatorToDestroy = GeneratorBlue;
} else {
    return 0;
}

if(global.winners == -1)
    global.winners = winTeam;
    
with (generatorToDestroy)
    instance_destroy();
    
recordEventInLog(7, winTeam, "", true);
