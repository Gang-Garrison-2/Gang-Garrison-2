// findDamageSourceIcon( damageSourceId )
// Returns the icon that should be used for the damage source, or a default icon
// if that damage source is not known.
var listIndex;
listIndex = argument0 - 1;

if(listIndex >= 0 and listIndex < ds_list_size(global.damageSourceIcons))
    return ds_list_find_value(global.damageSourceIcons, listIndex);
else
    return DeadKL;
