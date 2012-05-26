// Goes through all people of a select team and counts how many instances of a particular class there is.
// argument0 = team; argument1 = class

var count, player;
count = 0

// Wasn't sure whether I should use "with Player" or this, chose one randomly.
for (i=0; i<ds_list_size(global.players); i+=1)
{
    player = ds_list_find_value(global.players, i);
    if player.team == argument0 and player.class == argument1
    {
        count += 1;
    }
}

return count;
