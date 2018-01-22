// void initRewards()
// Prepares arrays

// Makes array of CLASS_ constants to class abbreviations

// CLASS_SCOUT
global.classAbbreviations[0] = "Sc";
// CLASS_SOLDIER
global.classAbbreviations[1] = "So";
// CLASS_SNIPER
global.classAbbreviations[2] = "Sn";
// CLASS_DEMOMAN
global.classAbbreviations[3] = "De";
// CLASS_MEDIC
global.classAbbreviations[4] = "Me";
// CLASS_ENGINEER
global.classAbbreviations[5] = "En";
// CLASS_HEAVY
global.classAbbreviations[6] = "He";
// CLASS_SPY
global.classAbbreviations[7] = "Sp";
// CLASS_PYRO
global.classAbbreviations[8] = "Py";
// CLASS_QUOTE
global.classAbbreviations[9] = "QC";

// Makes array of CLASS_ constants to BobbleHead overlay sprites
// CLASS_SCOUT
global.HatBobbleClassOverlay[0] = HatBobbleScoutS;
global.HatBobbleClassTaunt[0] = HatBobbleScoutTauntS;
// CLASS_SOLDIER
global.HatBobbleClassOverlay[1] = HatBobbleSoldierS;
global.HatBobbleClassTaunt[1] = HatBobbleSoldierTauntS;
// CLASS_SNIPER
global.HatBobbleClassOverlay[2] = HatBobbleSniperS;
global.HatBobbleClassTaunt[2] = HatBobbleSniperTauntS;
// CLASS_DEMOMAN
global.HatBobbleClassOverlay[3] = HatBobbleDemomanS;
global.HatBobbleClassTaunt[3] = HatBobbleDemoTauntS;
// CLASS_MEDIC
global.HatBobbleClassOverlay[4] = HatBobbleMedicS;
global.HatBobbleClassTaunt[4] = HatBobbleMedicTauntS;
// CLASS_ENGINEER
global.HatBobbleClassOverlay[5] = HatBobbleEngineerS;
global.HatBobbleClassTaunt[5] = HatBobbleEngiTauntS;
// CLASS_HEAVY
global.HatBobbleClassOverlay[6] = HatBobbleHeavyS;
global.HatBobbleClassTaunt[6] = HatBobbleHeavyTauntS;
global.HatBobbleSandwich[6] = HatBobbleOmnomnomnomS;
// CLASS_SPY
global.HatBobbleClassOverlay[7] = HatBobbleSpyS;
global.HatBobbleClassTaunt[7] = HatBobbleSpyRedTauntS; // Blue overlay will be substituted in code. I don't want to do this properly now because this will be removed anyway.
// CLASS_PYRO
global.HatBobbleClassOverlay[8] = HatBobblePyroS;
global.HatBobbleClassTaunt[8] = HatBobblePyroTauntS;
// None for CLASS_QUOTE

// Array of haxxy badge indexes (into the sprite) to reward names
global.HaxxyBadgesLength = 51;
global.HaxxyBadges[0] = 'Badge_Trn1Orng';
global.HaxxyBadges[1] = 'Badge_Trn1Gold';
global.HaxxyBadges[2] = 'Badge_Trn2Orng';
global.HaxxyBadges[3] = 'Badge_Trn2Gold';
global.HaxxyBadges[4] = 'Badge_Trn3Orng';
global.HaxxyBadges[5] = 'Badge_Trn3Gold';
global.HaxxyBadges[6] = 'Badge_RayBannDark';
global.HaxxyBadges[7] = 'Badge_RayBannLight';
global.HaxxyBadges[8] = 'Badge_CommunityGld';
global.HaxxyBadges[9] = 'Badge_CommunityGrn';
global.HaxxyBadges[10] = 'Badge_Dev';
global.HaxxyBadges[11] = 'Badge_Admn';
global.HaxxyBadges[12] = 'Badge_Haxxy';
global.HaxxyBadges[13] = 'Badge_RunnerRbn';
global.HaxxyBadges[14] = 'Badge_FirebugRbn';
global.HaxxyBadges[15] = 'Badge_RocketmanRbn';
global.HaxxyBadges[16] = 'Badge_OverweightRbn';
global.HaxxyBadges[17] = 'Badge_DetonatorRbn';
global.HaxxyBadges[18] = 'Badge_HealerRbn';
global.HaxxyBadges[19] = 'Badge_ConstructorRbn';
global.HaxxyBadges[20] = 'Badge_InfiltratorRbn';
global.HaxxyBadges[21] = 'Badge_RiflemanRbn';
global.HaxxyBadges[22] = 'Badge_Runner';
global.HaxxyBadges[23] = 'Badge_Firebug';
global.HaxxyBadges[24] = 'Badge_Rocketman';
global.HaxxyBadges[25] = 'Badge_Overweight';
global.HaxxyBadges[26] = 'Badge_Detonator';
global.HaxxyBadges[27] = 'Badge_Healer';
global.HaxxyBadges[28] = 'Badge_Constructor';
global.HaxxyBadges[29] = 'Badge_Infiltrator';
global.HaxxyBadges[30] = 'Badge_Rifleman';
global.HaxxyBadges[31] = 'Badge_Moneybag';
global.HaxxyBadges[32] = 'Badge_ChessWhite';
global.HaxxyBadges[33] = 'Badge_ChessBlack';
global.HaxxyBadges[34] = 'Badge_B-BallBlitz';
global.HaxxyBadges[35] = 'Badge_Elton-Jump-athon';
global.HaxxyBadges[36] = 'Badge_2spooky4u';
global.HaxxyBadges[37] = 'Badge_Rebel-ution';
global.HaxxyBadges[38] = 'Badge_GloryDays';
global.HaxxyBadges[39] = 'Badge_DynamicDuo';
global.HaxxyBadges[40] = 'Badge_ArmyOfOne';
global.HaxxyBadges[41] = 'Badge_ThreeMajor';
global.HaxxyBadges[42] = 'Badge_ThreeMinor';
global.HaxxyBadges[43] = 'Badge_ThreeCTF';
global.HaxxyBadges[44] = 'Badge_ThreeEtc';
global.HaxxyBadges[45] = 'Badge_ThreeKoTH';
global.HaxxyBadges[46] = 'Badge_BBall2015';
global.HaxxyBadges[47] = 'Badge_Elton2015';
global.HaxxyBadges[48] = 'Badge_InevitableOne2015';
global.HaxxyBadges[49] = 'Badge_Warpacks2015';
global.HaxxyBadges[50] = 'Badge_BannsLawsOfRobotics';

// Makes array of Golden Accessory overlay sprites
// Pre-initialize array to detect if sprites should be reused
for (i = CLASS_SCOUT; i <= CLASS_PYRO; i+= 1)
{
    global.GoldenAttireOverlay[i] = -1;
    global.GoldenAttireRunOverlay[i] = -1;
    global.GoldenAttireJumpOverlay[i] = -1;
    global.GoldenAttireLeanROverlay[i] = -1;
    global.GoldenAttireLeanLOverlay[i] = -1;
}
// CLASS_SCOUT
global.GoldenAttireOverlay[0] = ScoutGoldAttireStandS;
global.GoldenAttireRunOverlay[0] = ScoutGoldAttireRunS;
global.GoldenAttireJumpOverlay[0] = ScoutGoldAttireJumpS;
global.GoldenAttireLeanROverlay[0] = ScoutGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[0] = ScoutGoldAttireLeanLS;
global.GoldenAttireTaunt[0] = ScoutGoldAttireTauntS;
// CLASS_SOLDIER
global.GoldenAttireOverlay[1] = SoldierGoldAttireS;

global.GoldenAttireTaunt[1] = SoldierGoldAttireTauntS;
// CLASS_SNIPER
global.GoldenAttireOverlay[2] = SniperGoldAttireS;
global.GoldenAttireTaunt[2] = SniperGoldAttireTauntS;
// CLASS_DEMOMAN
global.GoldenAttireOverlay[3] = DemomanGoldAttireS;
global.GoldenAttireTaunt[3] = DemomanGoldAttireTauntS;
// CLASS_MEDIC
global.GoldenAttireOverlay[4] = MedicGoldAttireS;
global.GoldenAttireTaunt[4] = MedicGoldAttireTauntS;
// CLASS_ENGINEER
global.GoldenAttireOverlay[5] = EngineerGoldAttireStandS;
global.GoldenAttireRunOverlay[5] = EngineerGoldAttireRunS;
global.GoldenAttireJumpOverlay[5] = EngineerGoldAttireJumpS;
global.GoldenAttireLeanROverlay[5] = EngineerGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[5] = EngineerGoldAttireLeanLS;
global.GoldenAttireTaunt[5] = EngineerGoldAttireTauntS;
// CLASS_HEAVY
global.GoldenAttireOverlay[6] = HeavyGoldAttireS;
global.GoldenAttireTaunt[6] = HeavyGoldAttireTauntS;
global.GoldenSandwichOverlay[6] = OmnomnomnomGoldAttireS;
// CLASS_SPY
global.GoldenAttireOverlay[7] = SpyGoldAttireStandS;
global.GoldenAttireRunOverlay[7] = SpyGoldAttireRunS;
global.GoldenAttireJumpOverlay[7] = SpyGoldAttireJumpS;
global.GoldenAttireLeanROverlay[7] = SpyGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[7] = SpyGoldAttireLeanLS;
global.GoldenAttireTaunt[7] = SpyGoldAttireTauntS;
// CLASS_PYRO
global.GoldenAttireOverlay[8] = PyroGoldAttireS;
global.GoldenAttireTaunt[8] = PyroGoldAttireTauntS;
// None for CLASS_QUOTE
// fill in empty sprites
for (i = CLASS_SCOUT; i <= CLASS_PYRO; i+= 1)
{
    if (global.GoldenAttireRunOverlay[i] == -1)
        global.GoldenAttireRunOverlay[i] = global.GoldenAttireOverlay[i];
        
    if (global.GoldenAttireJumpOverlay[i] == -1)
        global.GoldenAttireJumpOverlay[i] = global.GoldenAttireOverlay[i];
        
    if (global.GoldenAttireLeanROverlay[i] == -1)
        global.GoldenAttireLeanROverlay[i] = global.GoldenAttireOverlay[i];
        
    if (global.GoldenAttireLeanLOverlay[i] == -1)
        global.GoldenAttireLeanLOverlay[i] = global.GoldenAttireOverlay[i];
}

// Array of Canadium accessories
// Pre-initialize array to detect if sprites should be reused
for (i = CLASS_SCOUT; i <= CLASS_PYRO; i+= 1)
{
    global.SilverAttireOverlay[i] = -1;
    global.SilverAttireRunOverlay[i] = -1;
    global.SilverAttireJumpOverlay[i] = -1;
    global.SilverAttireLeanROverlay[i] = -1;
    global.SilverAttireLeanLOverlay[i] = -1;
}
// CLASS_SCOUT
global.SilverAttireOverlay[0] = ScoutSilverAttireStandS;
global.SilverAttireRunOverlay[0] = ScoutSilverAttireRunS;
global.SilverAttireJumpOverlay[0] = ScoutSilverAttireJumpS;
global.SilverAttireLeanROverlay[0] = ScoutSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[0] = ScoutSilverAttireLeanLS;
global.SilverAttireTaunt[0] = ScoutSilverAttireTauntS;
// CLASS_SOLDIER
global.SilverAttireOverlay[1] = SoldierSilverAttireS;
global.SilverAttireTaunt[1] = SoldierSilverAttireTauntS;
// CLASS_SNIPER
global.SilverAttireOverlay[2] = SniperSilverAttireS;
global.SilverAttireTaunt[2] = SniperSilverAttireTauntS;
// CLASS_DEMOMAN
global.SilverAttireOverlay[3] = DemomanSilverAttireS;
global.SilverAttireTaunt[3] = DemomanSilverAttireTauntS;
// CLASS_MEDIC
global.SilverAttireOverlay[4] = MedicSilverAttireS;
global.SilverAttireTaunt[4] = MedicSilverAttireTauntS;
// CLASS_ENGINEER
global.SilverAttireOverlay[5] = EngineerSilverAttireStandS;
global.SilverAttireRunOverlay[5] = EngineerSilverAttireRunS;
global.SilverAttireJumpOverlay[5] = EngineerSilverAttireJumpS;
global.SilverAttireLeanROverlay[5] = EngineerSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[5] = EngineerSilverAttireLeanLS;
global.SilverAttireTaunt[5] = EngineerSilverAttireTauntS;
// CLASS_HEAVY
global.SilverAttireOverlay[6] = HeavySilverAttireS;
global.SilverAttireTaunt[6] = HeavySilverAttireTauntS;
global.SilverSandwichOverlay[6] = OmnomnomnomSilverAttireS;
// CLASS_SPY
global.SilverAttireOverlay[7] = SpySilverAttireStandS;
global.SilverAttireRunOverlay[7] = SpySilverAttireRunS;
global.SilverAttireJumpOverlay[7] = SpySilverAttireJumpS;
global.SilverAttireLeanROverlay[7] = SpySilverAttireLeanRS;
global.SilverAttireLeanLOverlay[7] = SpySilverAttireLeanLS;
global.SilverAttireTaunt[7] = SpySilverAttireTauntS;
// CLASS_PYRO
global.SilverAttireOverlay[8] = PyroSilverAttireS;
global.SilverAttireTaunt[8] = PyroSilverAttireTauntS;
// None for CLASS_QUOTE
// fill in empty sprites
for (i = CLASS_SCOUT; i <= CLASS_PYRO; i+= 1)
{
    if (global.SilverAttireRunOverlay[i] == -1)
        global.SilverAttireRunOverlay[i] = global.SilverAttireOverlay[i];
        
    if (global.SilverAttireJumpOverlay[i] == -1)
        global.SilverAttireJumpOverlay[i] = global.SilverAttireOverlay[i];
        
    if (global.SilverAttireLeanROverlay[i] == -1)
        global.SilverAttireLeanROverlay[i] = global.SilverAttireOverlay[i];
        
    if (global.SilverAttireLeanLOverlay[i] == -1)
        global.SilverAttireLeanLOverlay[i] = global.SilverAttireOverlay[i];
}

// Array of Top Hat + Monocle Package Deals
// CLASS_SCOUT
global.TopHatMonocleOverlay[0] = ScoutMonocleHatS;
global.TopHatMonocleTaunt[0] = ScoutMonocleHatTauntS;
// CLASS_SOLDIER
global.TopHatMonocleOverlay[1] = SoldierMonocleHatS;
global.TopHatMonocleTaunt[1] = SoldierMonocleHatTauntS;
// CLASS_SNIPER
global.TopHatMonocleOverlay[2] = SniperMonocleHatS;
global.TopHatMonocleTaunt[2] = SniperMonocleHatTauntS;
// CLASS_DEMOMAN
global.TopHatMonocleOverlay[3] = DemomanMonocleHatS;
global.TopHatMonocleTaunt[3] = DemomanMonocleHatTauntS;
// CLASS_MEDIC
global.TopHatMonocleOverlay[4] = MedicMonocleHatS;
global.TopHatMonocleTaunt[4] = MedicMonocleHatTauntS;
// CLASS_ENGINEER
global.TopHatMonocleOverlay[5] = EngineerMonocleHatS;
global.TopHatMonocleTaunt[5] = EngineerMonocleHatTauntS;
// CLASS_HEAVY
global.TopHatMonocleOverlay[6] = HeavyMonocleHatS;
global.TopHatMonocleTaunt[6] = HeavyMonocleHatTauntS;
global.TopHatMonocleSandwich[6] = OmnomnomnomMonocleHatS;
// CLASS_SPY
global.TopHatMonocleOverlay[7] = SpyMonocleHatS;
global.TopHatMonocleTaunt[7] = SpyMonocleHatS;
// CLASS_PYRO
global.TopHatMonocleOverlay[8] = PyroMonocleHatS;
global.TopHatMonocleTaunt[8] = PyroMonocleHatTauntS;
// Introducing the first ever Quote/Curly class reward
// CLASS_QUOTE
global.TopHatMonocleOverlay[9] = QuerlyMonocleHatS;
global.TopHatMonocleTaunt[9] = QuerlyRedMonocleHatTauntS; // Curly overlay will be substituted in code. I don't want to do this properly now because this will be removed anyway.

// CLASS_SCOUT
global.TopHatOverlay[0] = ScoutTopHatS;
global.TopHatTaunt[0] = ScoutTopHatTauntS;
// CLASS_SOLDIER
global.TopHatOverlay[1] = SoldierTopHatS;
global.TopHatTaunt[1] = SoldierTopHatTauntS;
// CLASS_SNIPER
global.TopHatOverlay[2] = SniperTopHatS;
global.TopHatTaunt[2] = SniperTopHatTauntS;
// CLASS_DEMOMAN
global.TopHatOverlay[3] = DemomanTopHatS;
global.TopHatTaunt[3] = DemomanTopHatTauntS;
// CLASS_MEDIC
global.TopHatOverlay[4] = MedicTopHatS;
global.TopHatTaunt[4] = MedicTopHatTauntS;
// CLASS_ENGINEER
global.TopHatOverlay[5] = EngineerTopHatS;
global.TopHatTaunt[5] = EngineerTopHatTauntS;
// CLASS_HEAVY
global.TopHatOverlay[6] = HeavyTopHatS;
global.TopHatTaunt[6] = HeavyTopHatTauntS;
global.TopHatSandwich[6] = OmnomnomnomTopHatS;
// CLASS_SPY
global.TopHatOverlay[7] = SpyTopHatS;
global.TopHatTaunt[7] = SpyTopHatS;
// CLASS_PYRO
global.TopHatOverlay[8] = PyroTopHatS;
global.TopHatTaunt[8] = PyroTopHatTauntS;
// CLASS_QUOTE
global.TopHatOverlay[9] = QuerlyTopHatS;
global.TopHatTaunt[9] = QuerlyRedTopHatTauntS; // Curly overlay will be substituted in code. I don't want to do this properly now because this will be removed anyway.
