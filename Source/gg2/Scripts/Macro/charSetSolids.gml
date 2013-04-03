with(IntelGate)
    solid =  (team != other.team and other.intel and !global.mapchanging);
with(TeamGate)
    solid = ((team != other.team or other.intel) and !global.mapchanging);
with(PlayerWall)
    solid = true;
with(PlayerWallHorizontal)
    solid = true;

