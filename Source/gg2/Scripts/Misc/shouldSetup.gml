//Check if we should do setup time for this map
if (global.setupTimer <= 0) {
    return false;
}
if(instance_exists(ControlPointHUD) and instance_exists(ControlPointSetupGate)) {
    return true;
}
if(!instance_exists(ArenaHUD) or !instance_exists(TeamDeathmatchHUD)) {
    return true;
}
return false;
