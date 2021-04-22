//Check if we should do setup time for this map
if (global.setupTimer <= 0) {
    return false;
}
if(instance_exists(ControlPointHUD) and instance_exists(ControlPointSetupGate)) {
    return true;
}
if(instance_exists(CTFHUD) or instance_exists(InvasionHUD) or instance_exists(KothHUD) or instance_exists(GeneratorHUD) or instance_exists(DKothHUD)) {
    return true;
}
return false;
