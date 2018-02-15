with(Obstacle)
    solid = true;
with(IntelGate)
    solid = true;
if(not global.mapchanging)
{
    with(TeamGate)
        solid = true;
}
if(areSetupGatesClosed())
{
    with(ControlPointSetupGate)
        solid = true;
}
with(BulletWall)
    solid = true;

