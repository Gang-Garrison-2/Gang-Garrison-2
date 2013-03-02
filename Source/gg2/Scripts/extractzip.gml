// used by loadserverplugins(), relies on 7za.exe Included File
// argument0 - Zip filename
// argument1 - Destination
// argument2 - Overwrite

var args;

args = 'x "'+argument0+'" -o"'+argument1+'"';

if (argument2) {
    args = args + ' -aoa';
}

execute_program("7za.exe", args, true);
