/*
The team given in argument0 has just destroyed the other team's bomb!
*/

if(argument0 == TEAM_RED) {
    winTeam = TEAM_BLUE;
    global.blueCaps += 1;
    with GeneratorRed instance_destroy();
} else if(argument0 == TEAM_BLUE) {
    winTeam = TEAM_RED
    global.redCaps += 1;
    with GeneratorBlue instance_destroy();
}
var myTeam;
myTeam = (winTeam == global.myself.team);
recordEventInLog(7, winTeam, "", myTeam);
