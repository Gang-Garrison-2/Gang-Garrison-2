/*
Adds a command to the TTS console from a file
argument0 - Command name
argument1 - Filename of file containing command script
*/
var fp, script;
TTS_addcommand(argument0,"execute_file('"+argument1+"',argument1);");
