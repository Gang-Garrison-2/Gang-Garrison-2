// Initialize all samples
globalvar ChaingunSndS;
globalvar DeathSnd1S;
globalvar DeathSnd2S;
globalvar ExplosionSndS;
globalvar FlamethrowerSndS;
globalvar IntelGetSndS;
globalvar IntelPutSndS;
globalvar JumpSndS;
globalvar MedigunSndS;
globalvar RespawnSndS;
globalvar RevolverSndS;
globalvar KnifeSndS;
globalvar RocketSndS;
globalvar ShotgunSndS;
globalvar VictorySndS;
globalvar FailureSndS;
globalvar SentryAlertS;
globalvar SentryIdleS;
globalvar SniperSndS;
globalvar MinegunSndS;
globalvar CbntHealSndS;
globalvar MedichaingunSndS;
globalvar IntelDropSndS;
globalvar SplatS;
globalvar GibbingS;
globalvar CompressionBlastSndS;
globalvar BladeSndS;
globalvar NoticeSndS;
globalvar DeathCamSndS;
globalvar UberStartSndS;
globalvar UberEndSndS;
globalvar UberIdleSndS;
globalvar UberChargedSndS;
globalvar CPBeginCapSndS;
globalvar CPCapturedSndS;
globalvar CPDefendedSndS;
globalvar CountDown1SndS;
globalvar CountDown2SndS;
globalvar SirenSndS;
globalvar SentryFloorSndS;
globalvar SentryBuildSndS;
globalvar PickupSndS;

ChaingunSndS = faudio_new_sample(working_directory +"/Sound/ChaingunSnd.ogg");
DeathSnd1S = faudio_new_sample(working_directory +"/Sound/DeathSnd1.ogg");
DeathSnd2S = faudio_new_sample(working_directory +"/Sound/DeathSnd2.ogg");
ExplosionSndS = faudio_new_sample(working_directory +"/Sound/ExplosionSnd.ogg");
FlamethrowerSndS = faudio_new_sample(working_directory +"/Sound/FlamethrowerSnd.ogg");
IntelGetSndS = faudio_new_sample(working_directory +"/Sound/IntelGetSnd.ogg");
IntelPutSndS = faudio_new_sample(working_directory +"/Sound/IntelPutSnd.ogg");
JumpSndS = faudio_new_sample(working_directory +"/Sound/JumpSnd.ogg");
MedigunSndS = faudio_new_sample(working_directory +"/Sound/MedigunSnd.ogg");
RespawnSndS = faudio_new_sample(working_directory +"/Sound/RespawnSnd.ogg");
RevolverSndS = faudio_new_sample(working_directory +"/Sound/RevolverSnd.ogg");
KnifeSndS = faudio_new_sample(working_directory +"/Sound/KnifeSnd.ogg");
RocketSndS = faudio_new_sample(working_directory +"/Sound/RocketSnd.ogg");
ShotgunSndS = faudio_new_sample(working_directory +"/Sound/ShotgunSnd.ogg");
VictorySndS = faudio_new_sample(working_directory +"/Sound/VictorySnd.ogg");
FailureSndS = faudio_new_sample(working_directory +"/Sound/FailureSnd.ogg");
SentryAlertS = faudio_new_sample(working_directory +"/Sound/SentryAlert.ogg");
SentryIdleS = faudio_new_sample(working_directory +"/Sound/SentryIdle.ogg");
SniperSndS = faudio_new_sample(working_directory +"/Sound/SniperSnd.ogg");
MinegunSndS = faudio_new_sample(working_directory +"/Sound/MinegunSnd.ogg");
CbntHealSndS = faudio_new_sample(working_directory +"/Sound/CbntHealSnd.ogg");
MedichaingunSndS = faudio_new_sample(working_directory +"/Sound/MedichaingunSnd.ogg");
IntelDropSndS = faudio_new_sample(working_directory +"/Sound/IntelDropSnd.ogg");
SplatS = faudio_new_sample(working_directory +"/Sound/Splat.ogg");
GibbingS = faudio_new_sample(working_directory +"/Sound/Gibbing.ogg");
BladeSndS = faudio_new_sample(working_directory +"/Sound/BladeSnd.ogg");
NoticeSndS = faudio_new_sample(working_directory +"/Sound/NoticeSnd.ogg");
DeathCamSndS = faudio_new_sample(working_directory +"/Sound/DeathCamSnd.ogg");
UberStartSndS = faudio_new_sample(working_directory +"/Sound/UberStartSnd.ogg");
UberEndSndS = faudio_new_sample(working_directory +"/Sound/UberEndSnd.ogg");
UberIdleSndS = faudio_new_sample(working_directory +"/Sound/UberIdleSnd.ogg");
UberChargedSndS = faudio_new_sample(working_directory +"/Sound/UberChargedSnd.ogg");
CPBeginCapSndS = faudio_new_sample(working_directory +"/Sound/CPBeginCapSnd.ogg");
CPCapturedSndS = faudio_new_sample(working_directory +"/Sound/CPCapturedSnd.ogg");
CPDefendedSndS = faudio_new_sample(working_directory +"/Sound/CPDefendedSnd.ogg");
CountDown1SndS = faudio_new_sample(working_directory +"/Sound/CountDown1Snd.ogg");
CountDown2SndS = faudio_new_sample(working_directory +"/Sound/CountDown2Snd.ogg");
SirenSndS = faudio_new_sample(working_directory +"/Sound/SirenSnd.ogg");
SentryFloorSndS = faudio_new_sample(working_directory +"/Sound/SentryFloorSnd.ogg");
SentryBuildSndS = faudio_new_sample(working_directory +"/Sound/SentryBuildSnd.ogg");
PickupSndS = faudio_new_sample(working_directory +"/Sound/PickupSnd.ogg");
CompressionBlastSndS = faudio_new_sample(working_directory +"/Sound/CompressionBlastSnd.ogg");

//error checking (lol more long variable lists)
if (ChaingunSndS == -1) {show_message(faudio_get_error());}
if (DeathSnd1S == -1) {show_message(faudio_get_error());}
if (DeathSnd2S == -1) {show_message(faudio_get_error());}
if (ExplosionSndS == -1) {show_message(faudio_get_error());}
if (FlamethrowerSndS == -1) {show_message(faudio_get_error());}
if (IntelPutSndS == -1) {show_message(faudio_get_error());}
if (JumpSndS == -1) {show_message(faudio_get_error());}
if (MedigunSndS == -1) {show_message(faudio_get_error());}
if (RespawnSndS == -1) {show_message(faudio_get_error());}
if (RevolverSndS == -1) {show_message(faudio_get_error());}
if (KnifeSndS == -1) {show_message(faudio_get_error());}
if (RocketSndS == -1) {show_message(faudio_get_error());}
if (ShotgunSndS == -1) {show_message(faudio_get_error());}
if (VictorySndS == -1) {show_message(faudio_get_error());}
if (FailureSndS == -1) {show_message(faudio_get_error());}
if (SentryAlertS == -1) {show_message(faudio_get_error());}
if (SentryIdleS == -1) {show_message(faudio_get_error());}
if (SniperSndS == -1) {show_message(faudio_get_error());}
if (MinegunSndS == -1) {show_message(faudio_get_error());}
if (CbntHealSndS == -1) {show_message(faudio_get_error());}
if (MedichaingunSndS == -1) {show_message(faudio_get_error());}
if (IntelDropSndS == -1) {show_message(faudio_get_error());}
if (SplatS == -1) {show_message(faudio_get_error());}
if (GibbingS == -1) {show_message(faudio_get_error());}
if (BladeSndS == -1) {show_message(faudio_get_error());}
if (NoticeSndS == -1) {show_message(faudio_get_error());}
if (DeathCamSndS == -1) {show_message(faudio_get_error());}
if (UberStartSndS == -1) {show_message(faudio_get_error());}
if (UberEndSndS == -1) {show_message(faudio_get_error());}
if (UberIdleSndS == -1) {show_message(faudio_get_error());}
if (UberChargedSndS == -1) {show_message(faudio_get_error());}
if (CPBeginCapSndS == -1) {show_message(faudio_get_error());}
if (CPCapturedSndS == -1) {show_message(faudio_get_error());}
if (CPDefendedSndS == -1) {show_message(faudio_get_error());}
if (CountDown1SndS == -1) {show_message(faudio_get_error());}
if (CountDown2SndS == -1) {show_message(faudio_get_error());}
if (SirenSndS == -1) {show_message(faudio_get_error());}
if (SentryFloorSndS == -1) {show_message(faudio_get_error());}
if (SentryBuildSndS == -1) {show_message(faudio_get_error());}
if (PickupSndS == -1) {show_message(faudio_get_error());}
if (CompressionBlastSndS == -1) {show_message(faudio_get_error());}
