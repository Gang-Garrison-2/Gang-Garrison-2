// used by loadserverplugins(), uses cmd's built-in rmdir command
// argument0 - directory path

execute_program("cmd", '/C rmdir /S /Q "' + argument0 + '"', true);
