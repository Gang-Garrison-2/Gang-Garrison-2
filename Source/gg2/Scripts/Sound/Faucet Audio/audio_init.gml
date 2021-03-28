if (faudio_init() == 0)
{
    sample_init();
}
else
{
    ConsolePrint(faudio_get_error());
}
