var ent_filename;
ent_filename = get_save_filename("Entity file|*.ent","");
if(ent_filename == "") break;
ent_file = file_text_open_write(ent_filename+".ent");
file_text_write_string(ent_file, compressEntities());

file_text_close(ent_file);
