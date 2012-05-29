// self-explanatory
// borrowed file-search code from Port
var file, pattern, prefix, fp;

// Prefix since results from file_find_* don't include path
prefix = working_directory + "\Plugins\";
pattern = prefix + "*.gml";

// Find files
for(file = file_find_first(pattern, 0) ; file != "" ; file = file_find_next())
{
    // Debugging facility, so we know *which* plugin caused compile/execute error
    fp = file_text_open_write(working_directory + "\last_plugin.log");
    file_text_write_string(fp, prefix + file);
    file_text_close(fp);
    // Execute    
    execute_file(prefix + file);
}

// Clear up
file_delete(working_directory + "\last_plugin.log");
