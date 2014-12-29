// void test_unit_end()
// Ends unit test.

if (global.testAssertionsSucceeded < global.testAssertions)
    show_message("Unit test FAILED, " + string(global.testAssertionsSucceeded) + "/" + string(global.testAssertions) + " assertions succeeded");
else
    show_message("Unit test PASSED, " + string(global.testAssertionsSucceeded) + "/" + string(global.testAssertions) + " assertions succeeded");

global.testAssertions = 0;
global.testAssertionsSucceeded = 0;
