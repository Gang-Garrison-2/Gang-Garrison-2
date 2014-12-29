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
if (is_string(a))
    message += '"' + a + '"';
else
    message += string(a);
message += " should be equal to ";
if (is_string(b))
    message += '"' + b + '"';
else
    message += string(b);

show_message(message);
