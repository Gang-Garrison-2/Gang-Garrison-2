with(IntelGate)
    solid = true;
with(TeamGate)
    solid = true;
with(ControlPointSetupGate)
{
    solid = (global.setupTimer > 0);
    if(instance_exists(FauxCPHUD))
        solid = (FauxCPHUD.cpUnlock > 0);
}
with(PlayerWall)
    solid = true;

