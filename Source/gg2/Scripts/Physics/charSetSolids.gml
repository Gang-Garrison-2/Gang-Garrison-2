with(Obstacle)
    solid = true;
with(IntelGate)
    solid =  (team != other.team and other.intel and !global.mapchanging);
with(TeamGate)
    solid = ((team != other.team or other.intel) and !global.mapchanging);
with(ControlPointSetupGate)
{
    solid = (global.setupTimer > 0);
    if(instance_exists(FauxCPHUD))
        solid = (FauxCPHUD.cpUnlock > 0);
}
with(PlayerWall)
    solid = true;

