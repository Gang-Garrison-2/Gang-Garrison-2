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
global.HatBobbleOverlay[6] = HatBobbleOmnomnomnomS;
// CLASS_SPY
global.HatBobbleClassOverlay[7] = HatBobbleSpyS;
global.HatBobbleClassTaunt[7] = HatBobbleSpyTauntS;
// CLASS_PYRO
global.HatBobbleClassOverlay[8] = HatBobblePyroS;
global.HatBobbleClassTaunt[8] = HatBobblePyroTauntS;
// None for CLASS_QUOTE

// Array of haxxy badge indexes (into the sprite) to reward names
global.HaxxyBadgesLength = 35;
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
global.HaxxyBadges[34] = 'Badge_BasketBall';

// Makes array of Golden Accessory overlay sprites
// CLASS_SCOUT
global.GoldenAttireOverlay[0] = ScoutGoldAttireStandS;
global.GoldenAttireRunOverlay[0] = ScoutGoldAttireRunS;
global.GoldenAttireJumpOverlay[0] = ScoutGoldAttireJumpS;
global.GoldenAttireLeanROverlay[0] = ScoutGoldAttireLeanRS;
global.GoldenAttireLeanLOverlay[0] = ScoutGoldAttireLeanLS;
global.GoldenAttireTaunt[0] = ScoutGoldAttireTauntS;
// CLASS_SOLDIER
global.GoldenAttireOverlay[1] = SoldierGoldAttireS;
global.GoldenAttireRunOverlay[1] = SoldierGoldAttireS;
global.GoldenAttireJumpOverlay[1] = SoldierGoldAttireS;
global.GoldenAttireLeanROverlay[1] = SoldierGoldAttireS;
global.GoldenAttireLeanLOverlay[1] = SoldierGoldAttireS;
global.GoldenAttireTaunt[1] = SoldierGoldAttireTauntS;
// CLASS_SNIPER
global.GoldenAttireOverlay[2] = SniperGoldAttireS;
global.GoldenAttireRunOverlay[2] = SniperGoldAttireS;
global.GoldenAttireJumpOverlay[2] = SniperGoldAttireS;
global.GoldenAttireLeanROverlay[2] = SniperGoldAttireS;
global.GoldenAttireLeanLOverlay[2] = SniperGoldAttireS;
global.GoldenAttireCrouchOverlay[2] = SniperGoldAttireS;
global.GoldenAttireTaunt[2] = SniperGoldAttireTauntS;
// CLASS_DEMOMAN
global.GoldenAttireOverlay[3] = DemomanGoldAttireS;
global.GoldenAttireRunOverlay[3] = DemomanGoldAttireS;
global.GoldenAttireJumpOverlay[3] = DemomanGoldAttireS;
global.GoldenAttireLeanROverlay[3] = DemomanGoldAttireS;
global.GoldenAttireLeanLOverlay[3] = DemomanGoldAttireS;
global.GoldenAttireTaunt[3] = DemomanGoldAttireTauntS;
// CLASS_MEDIC
global.GoldenAttireOverlay[4] = MedicGoldAttireS;
global.GoldenAttireRunOverlay[4] = MedicGoldAttireS;
global.GoldenAttireJumpOverlay[4] = MedicGoldAttireS;
global.GoldenAttireLeanROverlay[4] = MedicGoldAttireS;
global.GoldenAttireLeanLOverlay[4] = MedicGoldAttireS;
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
global.GoldenAttireRunOverlay[6] = HeavyGoldAttireS;
global.GoldenAttireJumpOverlay[6] = HeavyGoldAttireS;
global.GoldenAttireLeanROverlay[6] = HeavyGoldAttireS;
global.GoldenAttireLeanLOverlay[6] = HeavyGoldAttireS;
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
global.GoldenAttireRunOverlay[8] = PyroGoldAttireS;
global.GoldenAttireJumpOverlay[8] = PyroGoldAttireS;
global.GoldenAttireLeanROverlay[8] = PyroGoldAttireS;
global.GoldenAttireLeanLOverlay[8] = PyroGoldAttireS;
global.GoldenAttireTaunt[8] = PyroGoldAttireTauntS;
// None for CLASS_QUOTE

// Array of Canadium accessories
// CLASS_SCOUT
global.SilverAttireOverlay[0] = ScoutSilverAttireStandS;
global.SilverAttireRunOverlay[0] = ScoutSilverAttireRunS;
global.SilverAttireJumpOverlay[0] = ScoutSilverAttireJumpS;
global.SilverAttireLeanROverlay[0] = ScoutSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[0] = ScoutSilverAttireLeanLS;
global.SilverAttireTaunt[0] = ScoutSilverAttireTauntS;
// CLASS_SOLDIER
global.SilverAttireOverlay[1] = SoldierSilverAttireStandS;
global.SilverAttireRunOverlay[1] = SoldierSilverAttireRunS;
global.SilverAttireJumpOverlay[1] = SoldierSilverAttireJumpS;
global.SilverAttireLeanROverlay[1] = SoldierSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[1] = SoldierSilverAttireLeanLS;
global.SilverAttireTaunt[1] = SoldierSilverAttireTauntS;
// CLASS_SNIPER
global.SilverAttireOverlay[2] = SniperSilverAttireStandS;
global.SilverAttireRunOverlay[2] = SniperSilverAttireRunS;
global.SilverAttireJumpOverlay[2] = SniperSilverAttireJumpS;
global.SilverAttireLeanROverlay[2] = SniperSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[2] = SniperSilverAttireLeanLS;
global.SilverAttireCrouchOverlay[2] = SniperSilverAttireCrouchS;
global.SilverAttireTaunt[2] = SniperSilverAttireTauntS;
// CLASS_DEMOMAN
global.SilverAttireOverlay[3] = DemomanSilverAttireStandS;
global.SilverAttireRunOverlay[3] = DemomanSilverAttireRunS;
global.SilverAttireJumpOverlay[3] = DemomanSilverAttireJumpS;
global.SilverAttireLeanROverlay[3] = DemomanSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[3] = DemomanSilverAttireLeanLS;
global.SilverAttireTaunt[3] = DemomanSilverAttireTauntS;
// CLASS_MEDIC
global.SilverAttireOverlay[4] = MedicSilverAttireStandS;
global.SilverAttireRunOverlay[4] = MedicSilverAttireRunS;
global.SilverAttireJumpOverlay[4] = MedicSilverAttireJumpS;
global.SilverAttireLeanROverlay[4] = MedicSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[4] = MedicSilverAttireLeanLS;
global.SilverAttireTaunt[4] = MedicSilverAttireTauntS;
// CLASS_ENGINEER
global.SilverAttireOverlay[5] = EngineerSilverAttireStandS;
global.SilverAttireRunOverlay[5] = EngineerSilverAttireRunS;
global.SilverAttireJumpOverlay[5] = EngineerSilverAttireJumpS;
global.SilverAttireLeanROverlay[5] = EngineerSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[5] = EngineerSilverAttireLeanLS;
global.SilverAttireTaunt[5] = EngineerSilverAttireTauntS;
// CLASS_HEAVY
global.SilverAttireOverlay[6] = HeavySilverAttireStandS;
global.SilverAttireRunOverlay[6] = HeavySilverAttireRunS;
global.SilverAttireJumpOverlay[6] = HeavySilverAttireJumpS;
global.SilverAttireLeanROverlay[6] = HeavySilverAttireLeanRS;
global.SilverAttireLeanLOverlay[6] = HeavySilverAttireLeanLS;
global.SilverAttireWalkOverlay[6] = HeavySilverAttireWalkS;
global.SilverAttireTaunt[6] = HeavySilverAttireTauntS;
// CLASS_SPY
global.SilverAttireOverlay[7] = SpySilverAttireStandS;
global.SilverAttireRunOverlay[7] = SpySilverAttireRunS;
global.SilverAttireJumpOverlay[7] = SpySilverAttireJumpS;
global.SilverAttireLeanROverlay[7] = SpySilverAttireLeanRS;
global.SilverAttireLeanLOverlay[7] = SpySilverAttireLeanLS;
global.SilverAttireTaunt[7] = SpySilverAttireTauntS;
// CLASS_PYRO
global.SilverAttireOverlay[8] = PyroSilverAttireStandS;
global.SilverAttireRunOverlay[8] = PyroSilverAttireRunS;
global.SilverAttireJumpOverlay[8] = PyroSilverAttireJumpS;
global.SilverAttireLeanROverlay[8] = PyroSilverAttireLeanRS;
global.SilverAttireLeanLOverlay[8] = PyroSilverAttireLeanLS;
global.SilverAttireTaunt[8] = PyroSilverAttireTauntS;
// None for CLASS_QUOTE

// Array of Top Hat + Monocle Package Deals
// CLASS_SCOUT
global.TopHatMonocleOverlay[0] = ScoutMonocleHatStandS;
global.TopHatMonocleTaunt[0] = ScoutMonocleHatTauntS;
// CLASS_SOLDIER
global.TopHatMonocleOverlay[1] = SoldierMonocleHatStandS;
global.TopHatMonocleTaunt[1] = SoldierMonocleHatTauntS;
// CLASS_SNIPER
global.TopHatMonocleOverlay[2] = SniperMonocleHatStandS;
global.TopHatMonocleTaunt[2] = SniperMonocleHatTauntS;
// CLASS_DEMOMAN
global.TopHatMonocleOverlay[3] = DemomanMonocleHatStandS;
global.TopHatMonocleTaunt[3] = DemomanMonocleHatTauntS;
// CLASS_MEDIC
global.TopHatMonocleOverlay[4] = MedicMonocleHatStandS;
global.TopHatMonocleTaunt[4] = MedicMonocleHatTauntS;
// CLASS_ENGINEER
global.TopHatMonocleOverlay[5] = EngineerMonocleHatStandS;
global.TopHatMonocleTaunt[5] = EngineerMonocleHatTauntS;
// CLASS_HEAVY
global.TopHatMonocleOverlay[6] = HeavyMonocleHatStandS;
global.TopHatMonocleTaunt[6] = HeavyMonocleHatTauntS;
// CLASS_SPY
global.TopHatMonocleOverlay[7] = SpyMonocleHatStandS;
global.TopHatMonocleTaunt[7] = SpyMonocleHatTauntS;
// CLASS_PYRO
global.TopHatMonocleOverlay[8] = PyroMonocleHatStandS;
global.TopHatMonocleTaunt[8] = PyroMonocleHatTauntS;
// Introducing the first ever Quote/Curly class reward
// CLASS_QUOTE
/*global.TopHatMonocleOverlay[0] = QuoteMonocleHatStandS;
global.TopHatMonocleRunOverlay[0] = QuoteMonocleHatRunS;
global.TopHatMonocleTaunt[0] = QuoteMonocleHatTauntS;*/
