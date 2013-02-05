/*
Follows Standard Console API v1 spec
http://www.ganggarrison.com/forums/index.php?topic=33394

From the spec:

void ConsoleClear()
- Clears the console.
*/

ds_list_clear(global.ConsoleLog);
