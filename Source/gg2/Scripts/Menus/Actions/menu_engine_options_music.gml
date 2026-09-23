// EngineOptionsController: menu_addedit_select("Music:")
gg2_write_ini("Settings", "Music", argument0);
if(room != Options)
{
    if (argument0 == MUSIC_BOTH || argument0 == MUSIC_INGAME_ONLY)
    {
        AudioControlPlaySong(global.IngameMusic, true);
    }
    else
    {
        AudioControlPlaySong(-1, false);
    }
}
else
{
    if(argument0 == MUSIC_BOTH || argument0 == MUSIC_MENU_ONLY)
    {
        AudioControlPlaySong(global.MenuMusic, true);
    }
    else
    {
        AudioControlPlaySong(-1, false);
    }
}
