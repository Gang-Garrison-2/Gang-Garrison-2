// void test_assert_map_key_value(ds_map map, key, value)
// For use in unit tests. Asserts that a map has a key with a certain value

var map, key, value;
map = argument0;
key = argument1;
value = argument2;

global.testAssertions += 1;

if (!ds_map_exists(map, key))
{
    var message;
    message = "Assertion " + string(global.testAssertions) + " failed: Key ";
    message += value_to_string(key);
    message += " should exist in map, but does not";
    show_message(message);
    exit;
}

var actualValue;
actualValue = ds_map_find_value(map, key);

if (actualValue != value)
{
    var message;
    message = "Assertion " + string(global.testAssertions) + " failed: Key ";
    message += value_to_string(key);
    message += " in map should be equal to ";
    message += value_to_string(value);
    message += " but is actually ";
    message += value_to_string(actualValue);
    show_message(message);
    exit;
}

global.testAssertionsSucceeded += 1;
