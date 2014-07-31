// restart the game, e.g. because of unexpected data or to clean up the plugins

//Append each parameter
var params,a;
params = "-restart";
for(a = 1; a <= parameter_count(); a += 1)
{
  var p;
  p = parameter_string(a);
  if (p != "-restart")
  {
    params += " "+p;
  }
}

//Restart
execute_program(parameter_string(0), params, false);
game_end();
