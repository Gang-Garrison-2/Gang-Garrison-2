// Reads or writes a menu-bound variable by the name passed to menu_addedit_*.
// Replaces evaluating that name with execute_string, which ENIGMA can't run.
// New menu bindings need a line here.
// argument0: binding name, e.g. "global.fullscreen"
// argument1: true to assign argument2 first
// argument2: new value
// Returns the variable's value.
var name;
name = argument0;
if (name == "global.attack") { if (argument1) global.attack = argument2; return global.attack; }
if (name == "global.attemptPortForward") { if (argument1) global.attemptPortForward = argument2; return global.attemptPortForward; }
if (name == "global.autobalance") { if (argument1) global.autobalance = argument2; return global.autobalance; }
if (name == "global.caplimit") { if (argument1) global.caplimit = argument2; return global.caplimit; }
if (name == "global.changeClass") { if (argument1) global.changeClass = argument2; return global.changeClass; }
if (name == "global.changeTeam") { if (argument1) global.changeTeam = argument2; return global.changeTeam; }
if (name == "global.chat1") { if (argument1) global.chat1 = argument2; return global.chat1; }
if (name == "global.chat2") { if (argument1) global.chat2 = argument2; return global.chat2; }
if (name == "global.chat3") { if (argument1) global.chat3 = argument2; return global.chat3; }
if (name == "global.classlimits[CLASS_DEMOMAN]") { if (argument1) global.classlimits[CLASS_DEMOMAN] = argument2; return global.classlimits[CLASS_DEMOMAN]; }
if (name == "global.classlimits[CLASS_ENGINEER]") { if (argument1) global.classlimits[CLASS_ENGINEER] = argument2; return global.classlimits[CLASS_ENGINEER]; }
if (name == "global.classlimits[CLASS_HEAVY]") { if (argument1) global.classlimits[CLASS_HEAVY] = argument2; return global.classlimits[CLASS_HEAVY]; }
if (name == "global.classlimits[CLASS_MEDIC]") { if (argument1) global.classlimits[CLASS_MEDIC] = argument2; return global.classlimits[CLASS_MEDIC]; }
if (name == "global.classlimits[CLASS_PYRO]") { if (argument1) global.classlimits[CLASS_PYRO] = argument2; return global.classlimits[CLASS_PYRO]; }
if (name == "global.classlimits[CLASS_QUOTE]") { if (argument1) global.classlimits[CLASS_QUOTE] = argument2; return global.classlimits[CLASS_QUOTE]; }
if (name == "global.classlimits[CLASS_SCOUT]") { if (argument1) global.classlimits[CLASS_SCOUT] = argument2; return global.classlimits[CLASS_SCOUT]; }
if (name == "global.classlimits[CLASS_SNIPER]") { if (argument1) global.classlimits[CLASS_SNIPER] = argument2; return global.classlimits[CLASS_SNIPER]; }
if (name == "global.classlimits[CLASS_SOLDIER]") { if (argument1) global.classlimits[CLASS_SOLDIER] = argument2; return global.classlimits[CLASS_SOLDIER]; }
if (name == "global.classlimits[CLASS_SPY]") { if (argument1) global.classlimits[CLASS_SPY] = argument2; return global.classlimits[CLASS_SPY]; }
if (name == "global.down") { if (argument1) global.down = argument2; return global.down; }
if (name == "global.down2") { if (argument1) global.down2 = argument2; return global.down2; }
if (name == "global.drop") { if (argument1) global.drop = argument2; return global.drop; }
if (name == "global.fadeScoreboard") { if (argument1) global.fadeScoreboard = argument2; return global.fadeScoreboard; }
if (name == "global.frameratekind") { if (argument1) global.frameratekind = argument2; return global.frameratekind; }
if (name == "global.fullscreen") { if (argument1) global.fullscreen = argument2; return global.fullscreen; }
if (name == "global.gibLevel") { if (argument1) global.gibLevel = argument2; return global.gibLevel; }
if (name == "global.hideSpyGhosts") { if (argument1) global.hideSpyGhosts = argument2; return global.hideSpyGhosts; }
if (name == "global.hostingPort") { if (argument1) global.hostingPort = argument2; return global.hostingPort; }
if (name == "global.jump") { if (argument1) global.jump = argument2; return global.jump; }
if (name == "global.jump2") { if (argument1) global.jump2 = argument2; return global.jump2; }
if (name == "global.killCam") { if (argument1) global.killCam = argument2; return global.killCam; }
if (name == "global.killLimit") { if (argument1) global.killLimit = argument2; return global.killLimit; }
if (name == "global.killLogPos") { if (argument1) global.killLogPos = argument2; return global.killLogPos; }
if (name == "global.kothHudPos") { if (argument1) global.kothHudPos = argument2; return global.kothHudPos; }
if (name == "global.left") { if (argument1) global.left = argument2; return global.left; }
if (name == "global.left2") { if (argument1) global.left2 = argument2; return global.left2; }
if (name == "global.medic") { if (argument1) global.medic = argument2; return global.medic; }
if (name == "global.medicRadar") { if (argument1) global.medicRadar = argument2; return global.medicRadar; }
if (name == "global.monitorSync") { if (argument1) global.monitorSync = argument2; return global.monitorSync; }
if (name == "global.music") { if (argument1) global.music = argument2; return global.music; }
if (name == "global.particles") { if (argument1) global.particles = argument2; return global.particles; }
if (name == "global.playerLimit") { if (argument1) global.playerLimit = argument2; return global.playerLimit; }
if (name == "global.playerName") { if (argument1) global.playerName = argument2; return global.playerName; }
if (name == "global.queueJumping") { if (argument1) global.queueJumping = argument2; return global.queueJumping; }
if (name == "global.resolutionkind") { if (argument1) global.resolutionkind = argument2; return global.resolutionkind; }
if (name == "global.restartPrompt") { if (argument1) global.restartPrompt = argument2; return global.restartPrompt; }
if (name == "global.right") { if (argument1) global.right = argument2; return global.right; }
if (name == "global.right2") { if (argument1) global.right2 = argument2; return global.right2; }
if (name == "global.Server_RespawntimeSec") { if (argument1) global.Server_RespawntimeSec = argument2; return global.Server_RespawntimeSec; }
if (name == "global.serverName") { if (argument1) global.serverName = argument2; return global.serverName; }
if (name == "global.serverPassword") { if (argument1) global.serverPassword = argument2; return global.serverPassword; }
if (name == "global.showHealer") { if (argument1) global.showHealer = argument2; return global.showHealer; }
if (name == "global.showHealing") { if (argument1) global.showHealing = argument2; return global.showHealing; }
if (name == "global.showHealthBar") { if (argument1) global.showHealthBar = argument2; return global.showHealthBar; }
if (name == "global.showScores") { if (argument1) global.showScores = argument2; return global.showScores; }
if (name == "global.showTeammateStats") { if (argument1) global.showTeammateStats = argument2; return global.showTeammateStats; }
if (name == "global.shuffleRotation") { if (argument1) global.shuffleRotation = argument2; return global.shuffleRotation; }
if (name == "global.special") { if (argument1) global.special = argument2; return global.special; }
if (name == "global.taunt") { if (argument1) global.taunt = argument2; return global.taunt; }
if (name == "global.tdmInvulnerabilitySeconds") { if (argument1) global.tdmInvulnerabilitySeconds = argument2; return global.tdmInvulnerabilitySeconds; }
if (name == "global.timeLimitMins") { if (argument1) global.timeLimitMins = argument2; return global.timeLimitMins; }
if (name == "global.timerPos") { if (argument1) global.timerPos = argument2; return global.timerPos; }
if (name == "global.useLobbyServer") { if (argument1) global.useLobbyServer = argument2; return global.useLobbyServer; }
if (name == "global.welcomeMessage") { if (argument1) global.welcomeMessage = argument2; return global.welcomeMessage; }
show_error("Unknown menu binding: " + name, true);
return 0;
