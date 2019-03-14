//Adds 1 to the count for the specified player, in the specified kill table.
//If player is not found, add them to the table.
//Arg0: Killtable
//Arg1: Player
killtable_set(argument0, argument1, killtable_get(argument0, argument1) + 1);
