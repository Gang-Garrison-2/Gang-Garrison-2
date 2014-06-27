/*
Follows Standard Console API v1 spec
http://www.ganggarrison.com/forums/index.php?topic=33394

From the spec:

void ConsoleAddCommand(string name, string gml, string help)
- Adds the command, giving it the command name of name.
  When executed, the script gml is run, and the remainder of the command line
  after the command name and a space is passed as argument0 to that script. For
  example, if "kick foo bar" is typed, the argument0 is "foo bar". The value of
  help is used by the help command, see below.
*/

ds_list_add(global.ConsoleCommandNames,argument0);
ds_list_add(global.ConsoleCommandScripts,argument1);
ds_list_add(global.ConsoleCommandDocs,argument2);
