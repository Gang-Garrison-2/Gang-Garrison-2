// Returns the number of players in team <argument1> which have class <argument2>, not counting <argument0>

var count;
count = 0

with(Player)
{
    if (id != argument0 and team == argument1 and class == argument2)
        count += 1;
}

return count;
