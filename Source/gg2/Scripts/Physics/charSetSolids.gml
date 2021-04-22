with(Obstacle)
    solid = true;
    
if(!global.mapchanging)
{
    with(IntelGate)
        solid = (team != other.team and other.intel);

    with(TeamGate)
        solid = (team != other.team or other.intel);
}

if(areSetupGatesClosed())
{
    with(ControlPointSetupGate)
        solid = true;
}

if(shouldSetup())
{
    with(TeamGate)
        solid = true;
}

with(PlayerWall)
    solid = true;

