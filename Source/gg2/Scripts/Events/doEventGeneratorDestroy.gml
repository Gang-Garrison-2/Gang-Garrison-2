/*
The team given in argument0 has just destroyed the other team's bomb!
*/

if(argument0 == TEAM_RED) {
    if (global.winners == -1) global.winners = TEAM_BLUE;
    with GeneratorRed instance_destroy();
} else if(argument0 == TEAM_BLUE) {
    if (global.winners == -1) global.winners = TEAM_RED;
    with GeneratorBlue instance_destroy();
}
if (global.winners == -1) {
    var myTeam;
    myTeam = (argument0 == global.myself.team);
    recordEventInLog(7, winTeam, "", myTeam);
}
