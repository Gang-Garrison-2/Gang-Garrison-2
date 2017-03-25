/// Select and return an acceptable new class for a player, based on the classlimits.

var player, newTeam, desiredClass;
player       = argument0;
newTeam      = argument1;
desiredClass = argument2;

// Enough free slots for the desired class?
if (countClassmembersExcept(player, newTeam, desiredClass) < global.classlimits[desiredClass])
    return desiredClass;

// Uh-oh, too many have that class. Randomly select another.
var class, classlist;

// Make a list of all available classes except quote. Quote shouldn't be randomly assigned.
classlist = ds_list_create();
for (class=0; class<9; class+=1)
    if(countClassmembersExcept(player, newTeam, class) < global.classlimits[class])
        ds_list_add(classlist, class);

// Found teams with a free slot? Then choose one randomly.
if(!ds_list_empty(classlist))
{
    class = ds_list_find_value(classlist, irandom(ds_list_size(classlist)-1));
    ds_list_destroy(classlist);
    return class;
}
ds_list_destroy(classlist);

// Try quote as last resort
if (countClassmembersExcept(player, newTeam, CLASS_QUOTE) < global.classlimits[CLASS_QUOTE])
    return CLASS_QUOTE;

// Not enough slots, just use whatever was requested.
return desiredClass;
