// Returns the number of players in team <argument0> which have class <argument1>.

var count;
count = 0

with(Player)
{
    if (team == argument0 and class == argument1)
        count += 1;
}

return count;
