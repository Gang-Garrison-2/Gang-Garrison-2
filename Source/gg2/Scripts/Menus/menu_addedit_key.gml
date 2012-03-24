// argument0 - object (usually the caling object)
// argument1 - name
// argument2 - default value
// argument3 - GML code to run upon change (argument0 is value)

with (argument0)
{
    item_name[items] = argument1;
    item_type[items] = "editkey";
    item_value[items] = argument2;
    item_script[items] = argument3;
    items += 1;
}
