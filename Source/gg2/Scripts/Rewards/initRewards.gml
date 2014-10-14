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
global.HatBobbleClassRunOverlay[0] = HatBobbleScoutRunS;
global.HatBobbleClassTaunt[0] = HatBobbleScoutTauntS;
// CLASS_SOLDIER
global.HatBobbleClassOverlay[1] = HatBobbleSoldierS;
global.HatBobbleClassRunOverlay[1] = HatBobbleSoldierRunS;
global.HatBobbleClassTaunt[1] = HatBobbleSoldierTauntS;
// CLASS_SNIPER
global.HatBobbleClassOverlay[2] = HatBobbleSniperS;
global.HatBobbleClassRunOverlay[2] = HatBobbleSniperRunS;
global.HatBobbleClassCrouchOverlay[2] = HatBobbleSniperCrouchS;
global.HatBobbleClassTaunt[2] = HatBobbleSniperTauntS;
// CLASS_DEMOMAN
global.HatBobbleClassOverlay[3] = HatBobbleDemomanS;
global.HatBobbleClassRunOverlay[3] = HatBobbleDemomanRunS;
global.HatBobbleClassTaunt[3] = HatBobbleDemoTauntS;
// CLASS_MEDIC
global.HatBobbleClassOverlay[4] = HatBobbleMedicS;
global.HatBobbleClassRunOverlay[4] = HatBobbleMedicRunS;
global.HatBobbleClassTaunt[4] = HatBobbleMedicTauntS;
// CLASS_ENGINEER
global.HatBobbleClassOverlay[5] = HatBobbleEngineerS;
global.HatBobbleClassRunOverlay[5] = HatBobbleEngineerRunS;
global.HatBobbleClassTaunt[5] = HatBobbleEngiTauntS;
// CLASS_HEAVY
global.HatBobbleClassOverlay[6] = HatBobbleHeavyS;
global.HatBobbleClassRunOverlay[6] = HatBobbleHeavyRunS;
global.HatBobbleClassWalkOverlay[6] = HatBobbleHeavyWalkS;
global.HatBobbleClassTaunt[6] = HatBobbleHeavyTauntS;
// CLASS_SPY
global.HatBobbleClassOverlay[7] = HatBobbleSpyS;
global.HatBobbleClassRunOverlay[7] = HatBobbleSpyRunS;
global.HatBobbleClassTaunt[7] = HatBobbleSpyTauntS;
// CLASS_PYRO
global.HatBobbleClassOverlay[8] = HatBobblePyroS;
global.HatBobbleClassRunOverlay[8] = HatBobblePyroRunS;
global.HatBobbleClassTaunt[8] = HatBobblePyroTauntS;
// None for CLASS_QUOTE

// Array of haxxy badge indexes (into the sprite) to reward names
global.HaxxyBadgesLength = 34;
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

// Makes array of Golden Accessory overlay sprites
// TODO: import taunt sprites and raybanns sprites (ughhhh another set...)
// CLASS_SCOUT
global.GoldenAttireOverlay[0] = ScoutGoldAttireStandS;
global.GoldenAttireRunOverlay[0] = ScoutGoldAttireRunS;
global.GoldenAttireJumpOverlay[0] = ScoutGoldAttireJumpS;
global.GoldenAttireLeanROverlay[0] = ScoutGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[0] = ScoutGoldAttireLeanLS;
global.GoldenAttireTaunt[0] = ScoutGoldAttireTauntS;
// CLASS_SOLDIER
global.GoldenAttireOverlay[1] = SoldierGoldAttireStandS;
global.GoldenAttireRunOverlay[1] = SoldierGoldAttireRunS;
global.GoldenAttireJumpOverlay[1] = SoldierGoldAttireJumpS;
global.GoldenAttireLeanROverlay[1] = SoldierGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[1] = SoldierGoldAttireLeanLS;
global.GoldenAttireTaunt[1] = SoldierGoldAttireTauntS;
// CLASS_SNIPER
global.GoldenAttireOverlay[2] = SniperGoldAttireStandS;
global.GoldenAttireRunOverlay[2] = SniperGoldAttireRunS;
global.GoldenAttireJumpOverlay[2] = SniperGoldAttireJumpS;
global.GoldenAttireLeanROverlay[2] = SniperGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[2] = SniperGoldAttireLeanLS;
global.GoldenAttireCrouchOverlay[2] = SniperGoldAttireCrouchS;
global.GoldenAttireTaunt[2] = SniperGoldAttireTauntS;
// CLASS_DEMOMAN
global.GoldenAttireOverlay[3] = DemomanGoldAttireStandS;
global.GoldenAttireRunOverlay[3] = DemomanGoldAttireRunS;
global.GoldenAttireJumpOverlay[3] = DemomanGoldAttireJumpS;
global.GoldenAttireLeanROverlay[3] = DemomanGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[3] = DemomanGoldAttireLeanLS;
global.GoldenAttireTaunt[3] = DemomanGoldAttireTauntS;
// CLASS_MEDIC
global.GoldenAttireOverlay[4] = MedicGoldAttireStandS;
global.GoldenAttireRunOverlay[4] = MedicGoldAttireRunS;
global.GoldenAttireJumpOverlay[4] = MedicGoldAttireJumpS;
global.GoldenAttireLeanROverlay[4] = MedicGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[4] = MedicGoldAttireLeanLS;
global.GoldenAttireTaunt[4] = MedicGoldAttireTauntS;
// CLASS_ENGINEER
global.GoldenAttireOverlay[5] = EngineerGoldAttireStandS;
global.GoldenAttireRunOverlay[5] = EngineerGoldAttireRunS;
global.GoldenAttireJumpOverlay[5] = EngineerGoldAttireJumpS;
global.GoldenAttireLeanROverlay[5] = EngineerGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[5] = EngineerGoldAttireLeanLS;
global.GoldenAttireTaunt[5] = EngineerGoldAttireTauntS;
// CLASS_HEAVY
global.GoldenAttireOverlay[6] = HeavyGoldAttireStandS;
global.GoldenAttireRunOverlay[6] = HeavyGoldAttireRunS;
global.GoldenAttireJumpOverlay[6] = HeavyGoldAttireJumpS;
global.GoldenAttireLeanROverlay[6] = HeavyGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[6] = HeavyGoldAttireLeanLS;
global.GoldenAttireWalkOverlay[6] = HeavyGoldAttireWalkS;
global.GoldenAttireTaunt[6] = HeavyGoldAttireTauntS;
// CLASS_SPY
global.GoldenAttireOverlay[7] = SpyGoldAttireStandS;
global.GoldenAttireRunOverlay[7] = SpyGoldAttireRunS;
global.GoldenAttireJumpOverlay[7] = SpyGoldAttireJumpS;
global.GoldenAttireLeanROverlay[7] = SpyGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[7] = SpyGoldAttireLeanLS;
global.GoldenAttireTaunt[7] = SpyGoldAttireTauntS;
// CLASS_PYRO
global.GoldenAttireOverlay[8] = PyroGoldAttireStandS;
global.GoldenAttireRunOverlay[8] = PyroGoldAttireRunS;
global.GoldenAttireJumpOverlay[8] = PyroGoldAttireJumpS;
global.GoldenAttireLeanROverlay[8] = PyroGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[8] = PyroGoldAttireLeanLS;
global.GoldenAttireTaunt[8] = PyroGoldAttireTauntS;
// None for CLASS_QUOTE
