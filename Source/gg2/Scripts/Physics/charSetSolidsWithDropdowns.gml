// Context: Character object for which to set the solids

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

with(PlayerWall)
    solid = true;

if(!(keyState & $02))
{
    var charColBottom;
    charColBottom = bottom_bound_offset + y;
    if(frac(charColBottom) == 0.5)
        charColBottom = floor(charColBottom);
    else
        charColBottom = round(charColBottom);
        
    with(DropdownPlatform)
        solid = (charColBottom < round(y));
}
