// Decides what chat color a player should have, depending on host status, haxxy and team
// argument0 == player
if ds_list_find_index(global.players, argument0) == 0
{
    return COLOR_PURPLE;
}
else if argument0.isHaxxyWinner
{
    return COLOR_GOLD;
}
else if argument0.team == TEAM_RED
{
    return COLOR_RED;
}
else if argument0.team == TEAM_BLUE
{
    return COLOR_BLUE;
}
else
{
    // Spectators
    return COLOR_GREEN;
}
