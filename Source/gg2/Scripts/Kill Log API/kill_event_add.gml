// kill_event_add( sprite )
// creates a kill event with the given sprite
// returns the id which can be used to set a custom damage source

// start from 28 because the last kill log constant is 27
offset = ds_map_size(global.customDamageMap);
event_id = offset + 28;
ds_map_add(global.customDamageMap, event_id, argument0);
return event_id;

