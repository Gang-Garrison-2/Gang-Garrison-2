// default check, compatible with GM 8.0
if ((gamemaker_version != 810) or (not gamemaker_pro) or secure_mode)
    return false;

// specific behavior of GM 8.1.x builds without get_function_address()
// not sure if this is the best available solution, but it works
if (string_char_at('!', 0) != '')
    return false;

// check for a specific function that was introduced only in GM 8.1.141
// execute_string() prevents a "Unknown function or script" error
return execute_string("return get_function_address( 'clamp' );") > 0;

