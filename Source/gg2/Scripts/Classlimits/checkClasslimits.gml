// First checks whether the suggested class is acceptable, and if it isn't returns a random class
// argument0 == the team
// argument1 == the wanted class

if iterateThroughTeammates(argument0, argument1) < global.classlimits[argument1]
{
    return argument1// You're allowed to get the class you wished for.
}

// Uh-oh, too many have that class. Randomly select another.

var class, classlist;

classlist = ds_list_create()

for (a=0; a<=9; a+=1) ds_list_add(classlist, a)// Add all classes except quote to the list. Quote shouldn't be randomly assigned.

while !ds_list_empty(classlist)
{
    class = ds_list_find_value(classlist, random(ds_list_size(classlist)))// Get a random class
    if (iterateThroughTeammates(argument0, class) < global.classlimits[class])
    {
        ds_list_destroy(classlist);
        return class;
    }
    ds_list_delete(classlist, ds_list_find_index(classlist, class));
}
ds_list_destroy(classlist);

// Try quote as last resort
if (iterateThroughTeammates(argument0, CLASS_QUOTE) < global.classlimits[CLASS_QUOTE])
    return CLASS_QUOTE;

// Not enough slots, just use whatever was requested.
return argument1;
