// used by loadserverplugins(), relies on 7za.exe Included File
// argument0 - Zip filename
// argument1 - Destination

execute_program(temp_directory + "\7za.exe", 'x "'+argument0+'" -o"'+argument1+'" -aoa', true);
