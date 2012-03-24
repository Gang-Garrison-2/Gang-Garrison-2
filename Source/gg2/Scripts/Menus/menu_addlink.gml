// argument0 - object (usually the caling object)
// argument1 - name
// argument2 - GML code to execute

with (argument0)
{
    item_name[items] = argument1;
    item_type[items] = "script";
    item_script[items] = argument2;
    items += 1;
}
