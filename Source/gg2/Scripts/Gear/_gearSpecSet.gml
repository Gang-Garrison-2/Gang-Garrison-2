// _gearSpecSet(gearSpec, context, key, value)

var gearSpec, context, key, value;

gearSpec = argument0;
context = argument1;
key = argument2;
value = argument3;

if(ds_map_exists(gearSpec, context + " " + key))
{
    ds_map_replace(gearSpec, context + " " + key, value);
}
else
{
    ds_map_add(gearSpec, context + " " + key, value);
}
