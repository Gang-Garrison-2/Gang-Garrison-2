// Sets all head poses for all classes.


// Scout: Tracking the hair pixel
setBasicHeadPoses("Scout", -2, -14, 2, "0,0|-2,-2|-2,-2|0,-2|0,0|4,-2|4,-2|6,-2|2,-2");

// Soldier: Tracking the second-to-highest helmet pixel at the back of the head
setBasicHeadPoses("Soldier", -4, -16, 0, "0,0|-2,0|-4,2|-4,2|-4,2|-4,2|2,2,0,-1|2,2,0,-1|4,2,0,-1|-4,2|-2,4|-4,2|-2,4|-4,2|-2,0|0,0");

// Sniper: Tracking the pixel at the back of the head just below the hat
setBasicHeadPoses("Sniper", -4, -12, 2, "0,0|2,0|2,0|2,0|2,0|2,0|2,0|2,0|6,-2|6,-2|6,-2|2,0|0,0");
setHeadPosesFromString(SniperRedCrouchS, -4, -12, "0,4|0,4|0,4|0,4");
setHeadPosesFromString(SniperBlueCrouchS, -4, -12, "0,4|0,4|0,4|0,4");

// Demoman: Tracking the pixel at the back of the head just below the hairline
setBasicHeadPoses("Demoman", -1, -14, 2, "-2,-2|-2,-2|-2,-2|-4,-4|-6,-4|-6,-4|-6,-4|-4,-4|-2,-2|-2,-2|0,0");

// Medic: Tracking the back/low pixel of hair 
setBasicHeadPoses("Medic", -1, -16, 2, "0,0|0,0|2,0|2,0|4,0|4,0|8,6|19,12,-90|19,12,-90|8,6|4,0|0,0"); // 19,12 is rotated and perhaps the offsets before that as well.

// Engineer: Tracking the beard pixel just below the helmet
setBasicHeadPoses("Engineer", -2, -12, 2, "0,-2|0,-2|0,0|0,0|0,-4|0,-2|0,-2|0,-2|0,0|0,0|0,-4|0,-2|2,0");

// Heavy: Tracking the beard pixel at the back of the head
var heavyWalkHeadPoses, heavyOmnomnomnomHeadPoses;
heavyWalkHeadPoses = "0,0|0,0|0,0|0,0";
heavyOmnomnomnomHeadPoses = "2,0|4,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|6,0|8,2|4,0";
setBasicHeadPoses("Heavy", -7, -20, 2, "6,0|8,2|6,0|4,0|0,0|6,0|8,2|6,0|0,0|4,0|6,0|6,0");
setHeadPosesFromString(HeavyRedWalkS, -7, -20, heavyWalkHeadPoses);
setHeadPosesFromString(HeavyBlueWalkS, -7, -20, heavyWalkHeadPoses);
setHeadPosesFromString(HeavyRedOmnomnomnomS, -7, -20, heavyOmnomnomnomHeadPoses);
setHeadPosesFromString(HeavyBlueOmnomnomnomS, -7, -20, heavyOmnomnomnomHeadPoses);

// Spy: Tracking the pixel at the back of the head that's at the height of the eye slit
setBasicHeadPoses("Spy", -6, -20, 2, "0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0");

var spyStabPoses;
spyStabPoses = "0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0";
setHeadPosesFromString(SpyRedBackstabTorsoS, -6, -20, spyStabPoses);
setHeadPosesFromString(SpyBlueBackstabTorsoS, -6, -20, spyStabPoses);

// Pyro: Tracking the pixel just left of the eye
setBasicHeadPoses("Pyro", -1, -12, 2, "0,0|-6,0|-10,0|-12,0|-12,0|-12,0|-12,0|-10,0|-6,0|0,0"); // Hats should be partially covered

// Querly: Tracking the pixel at the back of the head at the vertical level of the highest eye pixel
setHeadPosesFromString(QuerlyRedTauntS, -7, -7, "0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|1,-1|3,-2|3,-2|2,-2|1,-1|0,0|0,0|0,0");
setHeadPosesFromString(QuerlyRedS, -7, -7, "0,0|0,-1|0,0|0,-1");
setHeadPosesFromString(QuerlyBlueTauntS, -7, -7, "0,0|0,0|0,0|1,1|1,1|1,1|1,1|1,1|1,1|1,1|1,1|1,1|-1,0|0,0|0,0|0,0|0,0");
setHeadPosesFromString(QuerlyBlueS, -7, -7, "0,0|0,-1|0,0|0,-1");
