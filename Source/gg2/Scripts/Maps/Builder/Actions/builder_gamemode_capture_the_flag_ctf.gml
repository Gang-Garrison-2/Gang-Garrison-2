// builder_init: addGamemode("Capture the flag (ctf)")
var redCount, blueCount;
redCount = 0;
blueCount = 0;
with(LevelEntity) {
    if (type == "redintel") redCount += 1;
    else if (type == "blueintel") blueCount += 1;
}
if (redCount != 1 || blueCount != 1) return false;
return true;
