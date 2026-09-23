// AdvHostOptionsController: menu_addedit_script("Map Rotation:")
var absPath;

absPath = get_open_filename("Map Rotation|*.txt", "");

if (absPath == "") {
    global.mapRotationFile = absPath;
} else {
    global.mapRotationFile = getRelativePathIfDescendant(working_directory + "/", absPath);
}

gg2_write_ini("Server", "MapRotation", global.mapRotationFile);

load_map_rotation();
return menu_format_maprotation_filepath(global.mapRotationFile);
