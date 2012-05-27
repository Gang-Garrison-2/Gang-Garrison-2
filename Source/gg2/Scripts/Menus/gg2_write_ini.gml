ini_open("gg2.ini");
if(is_string(argument2))
    ini_write_string(argument0, argument1, argument2);
else
    ini_write_real(argument0, argument1, argument2);
ini_close();
