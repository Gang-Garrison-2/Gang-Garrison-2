/* Insert a value into a sorted list, using binary search
   argument0: The list id
   argument1: The item to insert
   argument2: A script that acts as predicate function for comparing items in the list.
              It is expected to take two arguments, and return a value below 0 if the
              first argument is lower, above 0 if it is higher, and 0 if they are equal. */

var listId, item, predicate, upperBound, lowerBound;
listId = argument0;
item = argument1;
predicate = argument2;

lowerBound = 0; // The smallest possible insert pos
upperBound = ds_list_size(listId); // The greatest possible insert pos
while(lowerBound != upperBound)
{
    var middleIndex;
    middleIndex = floor((lowerBound+upperBound)/2);
    if(script_execute(predicate, item, ds_list_find_value(listId, middleIndex)) < 0)
        upperBound = middleIndex;
    else
        lowerBound = middleIndex+1; 
}

ds_list_insert(listId, lowerBound, item);
