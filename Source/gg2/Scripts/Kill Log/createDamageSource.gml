// createDamageSource( sprite )
// creates a damage source which can be used for the kill log
// returns the id of the damage source.

// We start from 1 because that's where the identifiers started before
// and I'm not 100% sure if 0 might have a special meaning somewhere...

ds_list_add(global.damageSourceIcons, argument0);
return ds_list_size(global.damageSourceIcons);

