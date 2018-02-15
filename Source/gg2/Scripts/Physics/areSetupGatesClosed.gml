var isSetup;

isSetup = (global.setupTimer > 0);

with(FauxCPHUD)
    isSetup = (cpUnlock > 0);
    
return isSetup;
