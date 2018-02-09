// Context: Character object for which to set the solids

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
