// void test_assert_eq(a, b)
// For use in unit tests. If a and b are not equal, errors.

var a, b;
a = argument0;
b = argument1;

global.testAssertions += 1;

if (is_real(a) == is_real(b))
{
    if (a == b)
    {
        global.testAssertionsSucceeded += 1;
        exit;
    }
}

var message;
message = "Assertion " + string(global.testAssertions) + " failed: ";
message += value_to_string(a);
message += " should be equal to ";
message += value_to_string(b);

show_message(message);
