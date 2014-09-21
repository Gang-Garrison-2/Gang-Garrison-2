var ent_filename, ent_file, temp, entityString;
ent_filename = get_open_filename("Entity file|*.ent","");
if(ent_filename == "") break;
with(LevelEntity) instance_destroy();
ent_file = file_text_open_read(ent_filename);
entityString = "";

//Validity check - the first line should be "{ENTITIES}".
temp = file_text_read_string(ent_file);
file_text_readln(ent_file);
if(temp != "{ENTITIES}")
{
    show_message("Error: Invalid entity data")
    return entityString;
}

while(!file_text_eof(ent_file))
{
    temp = file_text_read_string(ent_file);
    file_text_readln(ent_file);

    //Check for end of entities.
    if(temp == "{END ENTITIES}") 
        break;
    else
        entityString += temp + chr(10);
}

file_text_close(ent_file);
CustomMapCreateEntitiesFromEntityData(entityString);
