/*
Follows Standard Console API v1 spec
http://www.ganggarrison.com/forums/index.php?topic=33394

From the spec:

void ConsolePrint(string/real line)
- Prints the string or real line to the console. If the value is a real, it
  should be converted to a string. Any # characters should NOT display as
  new lines.
*/

ds_list_add(global.ConsoleLog, string(argument0));
while (ds_list_size(global.ConsoleLog) > 10) {
    ds_list_delete(global.ConsoleLog, 0);
}
